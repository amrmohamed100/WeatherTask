//
//  CurrentLocation.swift
//  WeatherTask
//
//  Created by Amr Mohamed on 17/03/2023.
//

import Foundation
import CoreLocation

class IntentHelper: NSObject {
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var lat: Double?
    var long: Double?
    
    static let sharedInstance = IntentHelper()
    
    func getCurrentCoordinates() {
        locManager.requestWhenInUseAuthorization()
        locManager.delegate = self
        locManager.requestLocation()
    }
}

extension IntentHelper: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Pass the result location back to the caller
        // For simplicity lets say we take the first location in list
        if let location = locations.first {
            lat = location.coordinate.latitude
            long = location.coordinate.longitude
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
        }
    }
    
}
