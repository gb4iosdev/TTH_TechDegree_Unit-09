//
//  Coordinate.swift
//  DiaryApp
//
//  Created by Gavin Butler on 16-11-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation
import CoreLocation

//2D coordinate structure
struct Coordinate {
    let latitude: Double
    let longitude: Double
}

extension Coordinate {
    
    //Initialize coordinate with a location
    init(location: CLLocation) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
}

extension Coordinate {
    
    //Return a CLLocationCoordinate2D from the coordinate to assist with map region creation
    func twoDimensional() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
