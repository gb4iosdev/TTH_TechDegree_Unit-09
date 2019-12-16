//
//  Reminder+CoreDataClass.swift
//  ProximityReminders
//
//  Created by Gavin Butler on 05-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//
//

import Foundation
import CoreData

public class Reminder: NSManagedObject {
    enum Error: LocalizedError {
        case titleMissing, addressMissing, detailMissing
        
        var errorDescription: String? {
            switch self {
            case .titleMissing: return "Please provide a title for the reminder"
            case .addressMissing: return "Please provide an address for the reminder"
            case .detailMissing: return "Please provide details for the reminder"
            }
        }
    }
    
    static func save(with title: String?, address: String?, detail: String?, creationDate: Date = Date(), recurring: Bool = false, uuid: UUID, arriving: Bool, location: Location? = nil, isActive: Bool = true) throws {
        guard let title = title, !title.isEmpty else { throw Error.titleMissing }
        guard let address = address, !address.isEmpty else { throw Error.addressMissing }
        guard let detail = detail, !detail.isEmpty else { throw Error.detailMissing }
        
        let reminder = Reminder(context: CoreDataStack.shared.managedObjectContext)
        reminder.title = title
        reminder.address = address
        reminder.detail = detail
        reminder.creationDate = creationDate
        reminder.recurring = recurring
        reminder.uuid = uuid
        reminder.arriving = arriving
        reminder.isActive = isActive
        
        if let location = location {
            reminder.location = location
        }
        
        CoreDataStack.shared.managedObjectContext.saveChanges()
    }
}
