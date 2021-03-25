//
//  GeoDecoder.swift
//  uikit-virta-demo
//
//  Created by abbasi on 21.3.2021.
//

import Foundation
import  Combine
import CoreLocation
class GeoDecoder {
    @Published private var stations:[Station] = []
    private var decodedStations:[Station] = []
    let geocoder = CLGeocoder()
    private var cancellableSet: Set<AnyCancellable> = []
    init() {
        
        
    }
    func startDecoding(stations:[Station]) {
        self.stations = stations
        
        Publishers.Sequence(sequence: stations)
            .subscribe(on: DispatchQueue.global())
            .flatMap(maxPublishers: .max(1)) { (station)  in
                self.geocoder.reverseGeocodeLocationPublisher(station)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
            
            }) { station,address in
            station.address = address
        }.store(in: &cancellableSet)
        
        
         
    }
    
}


extension CLGeocoder {
    func reverseGeocodeLocationPublisher(_ station: Station, preferredLocale locale: Locale? = nil) -> AnyPublisher<(Station,String), Error> {
        Future<(Station,String), Error> { promise in
            let location = CLLocation(latitude: station.latitude, longitude: station.longitude)
            return self.reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, error in
                guard let placemark = placemarks?.first else {
                    return promise(.failure(error ?? CLError(.geocodeFoundNoResult)))
                }
                let address = placemark.makeAddressString()
                return promise(.success((station,address)))
            }
        }.eraseToAnyPublisher()
    }
}

extension CLPlacemark {

    func makeAddressString() -> String {
        var combined = ""
        if let first = subThoroughfare, !first.isEmpty {
            combined += first
            combined = combined.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if let second = thoroughfare, !second.isEmpty {
            combined += " " + second
            combined = combined.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if let third = locality, !third.isEmpty {
            if combined.isEmpty {
                combined += "" + third
                combined = combined.trimmingCharacters(in: .whitespacesAndNewlines)
            }else{
                combined += ", " + third
                combined = combined.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        return combined
    }
}
