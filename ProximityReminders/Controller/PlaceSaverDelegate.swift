//
//  PlaceSaverDelegate.swift
//  ProximityReminders
//
//  Created by Gavin Butler on 04-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import MapKit

protocol PlaceSaverDelegate: class {
    func savePlace(_: MKMapItem)
}
