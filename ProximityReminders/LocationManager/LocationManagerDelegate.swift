//
//  LocationManagerDelegate.swift
//  DiaryApp
//
//  Created by Gavin Butler on 20-11-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import CoreLocation

//Adopters must have a response for when user’s location is found or not found.
protocol LocationManagerDelegate: class {
    func obtainedCoordinates(_ coordinate: Coordinate)
    func failedWithError(_ error: LocationError)
}
