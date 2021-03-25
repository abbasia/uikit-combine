//
//  AppModel.swift
//  uikit-virta-demo
//
//  Created by abbasi on 15.3.2021.
//

import Foundation
import Combine
import CoreLocation

enum FetchState {
    case started
    case success
    case error
    case none
}

final class AppModel {
    
    let network = NetworkService()
    let locationProxy = LocationProxy()
    let geoDecoder = GeoDecoder()
    
    @Published private(set) var authToken:String? = nil
    @Published private(set) var stations: [Station] = []
    @Published var userLocation: CLLocation?
    @Published var fetchState: FetchState = .none
    
    var cancellable = Set<AnyCancellable>()
    
    var isLoggedInPublisher: AnyPublisher<Bool, Never> {
        $authToken.map { (token) -> Bool in
            return token != nil ? true : false
        }.eraseToAnyPublisher()
    }
    
    var stationsWithDistanceFromUserPublisher: AnyPublisher<[Station], Never> {
        Publishers.CombineLatest($stations,$userLocation).map { (stations,userLocation) -> [Station]  in
            if userLocation != nil {
                let mapped = stations.map { (station) -> Station in
                    let s: Station = station
                    let stationLocation = CLLocation(latitude: station.latitude, longitude: station.longitude)
                    let distanceFromUser = stationLocation.distance(from: userLocation!)
                    s.distanceFromUser = distanceFromUser
                    return s
                }
                return mapped
            }
            return stations
        }.eraseToAnyPublisher()
    }
    
    var sortedStationsByDistance: AnyPublisher<[Station], Never> {
        stationsWithDistanceFromUserPublisher.map({ (stations)  in
            return stations.sorted{ $0.distanceFromUser < $1.distanceFromUser}
            }).eraseToAnyPublisher()
    }
    
    func fetchStations(){
        if fetchState == .started && authToken == nil  {return}
        fetchState = .started
    
        network.fetchStations(token: authToken!, locationContainer: locationProxy.locationContainer(radiusInKm: 40))
            .map({ (stations) in
                return stations.filter { (station) -> Bool in
                    station.connectors.count > 0
                }
            })
            .sink { [weak self] status in
                switch status {
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.fetchState = .error
                    break
                case .finished:
                    print("fetch stations finished ")
                    self?.fetchState = .none
                    break
                }
                
            } receiveValue: { [weak self] (stations) in
                self?.stations = stations
                self?.fetchState = .success
            }.store(in: &cancellable)

        
    }
    
    init() {
        self.authToken =  Storage.getToken()
        subscribeToLocationProxy()
        getUserLocation()
        
    }
    
    func subscribeToLocationProxy() {
        locationProxy
            .$location
            .assign(to: \.userLocation, on: self)
            .store(in: &cancellable)
    }
    
    func getUserLocation(){
        locationProxy.requestAuthorization()
        locationProxy.startUpdaingLocation()
    }
    
    func setToken(t: String) {
        Storage.setToken(token: t)
        self.authToken = t
    }
}
