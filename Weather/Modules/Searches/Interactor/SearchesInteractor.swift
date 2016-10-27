//
//  SearchesInteractor.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import UIKit
import CoreLocation

protocol SearchesInteractorInput: class {
    // Methods to retrieve data
    func getLocation()
}

protocol SearchesInteractorOutput: class {
    // Methods to send data
    func didGetLocation(location: CLLocation)
    func didFailStartingLocation(message: String)
}

// Note, we need to subclass from NSObject in order to conform CLLocationManagerDelegate protocol
class SearchesInteractor: NSObject {
    weak var output: SearchesInteractorOutput!
    let locationManager = CLLocationManager()
    
    private func shouldStartUpdatingLocation(status: CLAuthorizationStatus) -> Bool {
        switch status {
        case .denied:
            return false
        case .restricted:
            return false
        default:
            return true
        }
    }
    
    private func shouldAskForPermissionLocation(status: CLAuthorizationStatus) -> Bool {
        switch status {
        case .notDetermined:
            return true
        default:
            return false
        }
    }
    
    internal func startUpdatingUserLocation(status: CLAuthorizationStatus) -> Bool {
        
        if shouldStartUpdatingLocation(status: status) == false {
            return false
        }
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.delegate = self
            
            if shouldAskForPermissionLocation(status: status) {
                locationManager.requestWhenInUseAuthorization()
            } else {
                locationManager.requestLocation()
            }   
        }
        
        return true
    }
    
    internal func stopUpdatingUserLocation() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
}

extension SearchesInteractor: SearchesInteractorInput {
    
    internal func getLocation() {
        if startUpdatingUserLocation(status: CLLocationManager.authorizationStatus()) == false {
            let message = NSLocalizedString("I couldn't get your location.\nCheck your system preferences.", comment: "")
            output.didFailStartingLocation(message: message)
        }
    }
}

extension SearchesInteractor: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            stopUpdatingUserLocation()
            output.didGetLocation(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        stopUpdatingUserLocation()
        let message = NSLocalizedString("I couldn't get your location.\nCheck your system preferences.", comment: "")
        output.didFailStartingLocation(message: message)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if startUpdatingUserLocation(status: status) == false {
            stopUpdatingUserLocation()
            let message = NSLocalizedString("I couldn't get your location.\nCheck your system preferences.", comment: "")
            output.didFailStartingLocation(message: message)
        }
    }
}
