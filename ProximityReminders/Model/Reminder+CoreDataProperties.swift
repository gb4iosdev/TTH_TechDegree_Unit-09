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

    @nonobjc public class func remindersFetchRequest() -> NSFetchRequest<Reminder> {
        let fetchRequest = NSFetchRequest<Reminder>(entityName: "Reminder")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Reminder.isActive, ascending: false), NSSortDescriptor(keyPath: \Reminder.creationDate, ascending: false)]
        return fetchRequest
    }

    @NSManaged public var title: String
    @NSManaged public var detail: String?
    @NSManaged public var arriving: Bool
    @NSManaged public var isActive: Bool
    @NSManaged public var recurring: Bool
    @NSManaged public var address: String
    @NSManaged public var uuid: UUID
    @NSManaged public var creationDate: Date
    
    @NSManaged public var location: Location

}


