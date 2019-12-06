//
//  Location+CoreDataProperties.swift
//  ProximityReminders
//
//  Created by Gavin Butler on 06-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var reminder: Reminder?

}
