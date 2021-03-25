//
//  LocationProxy.swift
//  uikit-virta-demo
//
//  Created by abbasi on 20.3.2021.
//


import Foundation
import Combine
import CoreLocation

struct LocationContainer {
    let minLat: CLLocationDegrees
    let maxLat: CLLocationDegrees
    let minLong: CLLocationDegrees
    let maxLong: CLLocationDegrees
    
}

final class LocationProxy: NSObject, CLLocationManagerDelegate{
    let manager: CLLocationManager = CLLocationManager()
    @Published var location:CLLocation? = nil
    
    override init() {
        super.init()
        manager.delegate = self
        manager.activityType = .automotiveNavigation
        manager.distanceFilter = 150
    }
    func requestAuthorization(){
        manager.requestWhenInUseAuthorization()
    }
    func startUpdaingLocation(){
        manager.startUpdatingLocation()
    }
    
    func stopUpdaingLocation(){
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        self.location = location
    }
    
    func locationContainer(radiusInKm: Double) -> LocationContainer? {
        if let location = location {
            let location1 = location.coordinate.shift(byDistance: radiusInKm*1000, azimuth: 3*Double.pi/4)
            let location2 = location.coordinate.shift(byDistance: radiusInKm*1000, azimuth: -Double.pi/4)
            return LocationContainer(
                minLat: min(location1.latitude, location2.latitude),
                maxLat: max(location1.latitude, location2.latitude),
                minLong: min(location1.longitude, location2.longitude),
                maxLong: max(location1.longitude, location2.longitude))
        }else {
            return nil
        }
    }
    
    
}

extension CLLocationCoordinate2D {

    /// Get coordinate moved from current to `distanceMeters` meters with azimuth `azimuth` [0, Double.pi)
    ///
    /// - Parameters:
    ///   - distanceMeters: the distance in meters
    ///   - azimuth: the azimuth (bearing) north = 0, south =  Double.pi, West = pi/2, East = -pi/2
    /// - Returns: new coordinate
    func shift(byDistance distanceMeters: Double, azimuth: Double) -> CLLocationCoordinate2D {
        let bearing = azimuth
        let origin = self
        let distRadians = distanceMeters / (6372797.6) // earth radius in meters

        let lat1 = origin.latitude * Double.pi / 180
        let lon1 = origin.longitude * Double.pi / 180

        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearing))
        let lon2 = lon1 + atan2(sin(bearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
        return CLLocationCoordinate2D(latitude: lat2 * 180 / Double.pi, longitude: lon2 * 180 / Double.pi)
    }
}
