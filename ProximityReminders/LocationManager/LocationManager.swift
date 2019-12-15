//
//  LocationManager.swift
//  DiaryApp
//
//  Created by Gavin Butler on 12-05-2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import Foundation
import CoreLocation

//final class LocationManager {
//
//    static let sharedManager = CLLocationManager()
//}

//Acts as Apple’s CLLocationManagerDelegate so that it can respond to location finding events, and informs it’s delegates of locations and permission events.
/*class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    weak var permissionsDelegate: LocationPermissionsDelegate?
    weak var locationsDelegate: LocationManagerDelegate?
    
    init(locationsDelegate: LocationManagerDelegate?, permissionsDelegate: LocationPermissionsDelegate?) {
        self.permissionsDelegate = permissionsDelegate
        self.locationsDelegate = locationsDelegate
        super.init()
        manager.delegate = self
    }
    
    //Note static variable accessing authorization class function on CLLocationManager (can be set or unset only by user)
    static var isAuthorized: Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse: return true
        default: return false
        }
    }
    
    //Informs caller of status and launches alert (via manager.requestWhenInUseAuthorization()) if user input is required
    func requestLocationAuthorization() throws {
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == .restricted || authorizationStatus == .denied {
            throw LocationError.disallowedByUser
        } else if authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else {
            return
        }
    }
    
    //Trigger the location manager to look for the location (responds via the delegate methods below, particularly didUpdateLocations)
    func requestLocation() {
        manager.requestLocation()
    }
    
    //Keep the permissions delegate informed of changes to authorization status coming from the CLLocationManager
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            permissionsDelegate?.authorizationSucceeded()
        } else if status == .restricted || status == .denied {
            permissionsDelegate?.authorizationFailedWithStatus(status)
        } else {
            return
        }
    }
    
    //Keep the locations delegate informed of failure when the CLLocationManager tried to determine location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let error = error as? CLError else {
            locationsDelegate?.failedWithError(.unknownError)
            return
        }
        
        switch error.code {
        case .locationUnknown, .network: locationsDelegate?.failedWithError(.unableToFindLocation)
        case .denied: locationsDelegate?.failedWithError(.disallowedByUser)
        default: return
        }
    }
    
    //Happy delegate path – inform the locations delegate of the updated location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            locationsDelegate?.failedWithError(.unableToFindLocation)
            return
        }
        
        let coordinate = Coordinate(location: location)
        
        locationsDelegate?.obtainedCoordinates(coordinate)
        
    }
}*/
