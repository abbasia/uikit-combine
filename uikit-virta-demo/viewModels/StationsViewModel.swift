//
//  StationsViewModel.swift
//  uikit-virta-demo
//
//  Created by abbasi on 16.3.2021.
//

import Foundation
import Combine
import UIKit
import CoreLocation

class StationsViewModel {
    
    let appModel: AppModel
    
    @Published var showKw: Bool = true
    @Published var showDistance: Bool = true
    @Published var sortedStations = [Station]()
    
    var cancellable = Set<AnyCancellable>()
    
    var top10StationsPublisher: AnyPublisher<([Station]),Never>{
        appModel.sortedStationsByDistance
            .map({ (stations)  in
                let arraySlice = stations.prefix(10)
                return Array(arraySlice)
            }).eraseToAnyPublisher()
            
    }
    
    func subscribeToPublishers(){
        top10StationsPublisher
            .assign(to: \.sortedStations, on: self)
            .store(in: &cancellable)
        
        $sortedStations.sink { [weak self] (stations) in
            self?.appModel.geoDecoder.startDecoding(stations: stations)
        }
        .store(in: &cancellable)
        
    }
    
    init(_ appModel: AppModel) {
        self.appModel = appModel
        subscribeToPublishers()
    }
    
}
