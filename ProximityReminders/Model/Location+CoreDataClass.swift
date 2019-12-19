//
//  Location+CoreDataClass.swift
//  ProximityReminders
//
//  Created by Gavin Butler on 06-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//
//

import Foundation
import CoreData
import MapKit

//Captures coordinate for location/place chosen in the PlaceSearchController
public class Location: NSManagedObject {
    enum Error: LocalizedError {
        case longitudeMissing, latitudeMissing
        
        var errorDescription: String? {
            switch self {
            case .latitudeMissing: return "Couldn't obtain latitude for the location"
            case .longitudeMissing: return "Couldn't obtain longitude for the location"
            }
        }
    }
    
    //Creates a new Location object and saves to the managed object context
    static func save(with longitude: Double?, and latitude: Double?) throws -> Location {
        guard let longitude = longitude else { throw Error.longitudeMissing }
        guard let latitude = latitude else { throw Error.latitudeMissing }
        
        let location = Location(context: CoreDataStack.shared.managedObjectContext)
        location.longitude = longitude
        location.latitude = latitude
        CoreDataStack.shared.managedObjectContext.saveChanges()
        
        return location
    }
    
    //Converts from CLLocationCoordinate2D to a Location object
    class func fromCLLocationCoordinate2D(coordinate2d: CLLocationCoordinate2D) -> Location {
        let location = Location(context: CoreDataStack.shared.managedObjectContext)
        location.latitude = coordinate2d.latitude
        location.longitude = coordinate2d.longitude
        return location
    }
    
    //Returns a CLLocationCoordinate2D object using this location's properties
    func asCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(self.latitude, self.longitude)
    }
}
