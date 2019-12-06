//
//  Reminder+CoreDataProperties.swift
//  ProximityReminders
//
//  Created by Gavin Butler on 05-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged public var title: String
    @NSManaged public var detail: String?
    @NSManaged public var arriving: Bool
    @NSManaged public var recurring: Bool
    @NSManaged public var address: String
    
    @NSManaged public var location: Location

}
