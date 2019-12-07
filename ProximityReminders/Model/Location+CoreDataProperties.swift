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
import MapKit


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var reminder: Reminder?
    
    class func fromCLLocationCoordinate2D(coordinate2d: CLLocationCoordinate2D) -> Location {
        let location = Location(context: CoreDataStack.shared.managedObjectContext)
        location.latitude = coordinate2d.latitude
        location.longitude = coordinate2d.longitude
        return location
    }
    
    func asCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(self.latitude, self.longitude)
    }

}
