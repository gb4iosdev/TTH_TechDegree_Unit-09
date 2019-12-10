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
    
    static func save(with longitude: Double?, and latitude: Double?) throws -> Location {
        guard let longitude = longitude else { throw Error.longitudeMissing }
        guard let latitude = latitude else { throw Error.latitudeMissing }
        
        let location = Location(context: CoreDataStack.shared.managedObjectContext)
        location.longitude = longitude
        location.latitude = latitude
        CoreDataStack.shared.managedObjectContext.saveChanges()
        
        return location
    }
}
