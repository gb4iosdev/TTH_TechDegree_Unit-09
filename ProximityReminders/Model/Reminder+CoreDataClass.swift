//
//  Reminder+CoreDataClass.swift
//  ProximityReminders
//
//  Created by Gavin Butler on 05-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//
//

import CoreData
import UIKit

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
    
    public class func remindersFetchRequest() -> NSFetchRequest<Reminder> {
        
        let fetchRequest: NSFetchRequest<Reminder> = self.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Reminder.isActive, ascending: false), NSSortDescriptor(keyPath: \Reminder.creationDate, ascending: false)]
        return fetchRequest
    }
    
    //Creates a new Reminder object and saves to the managed object context
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
    
    //Returns a reminder with the specified UUID from the context if found, else nil
    static func with(uuid: UUID) -> Reminder? {
        
        let reminderFetchRequest: NSFetchRequest<Reminder> = self.fetchRequest()
        reminderFetchRequest.predicate = NSPredicate(format: "uuid = %@", uuid.uuidString)
        
        do {
            let reminder = try CoreDataStack.shared.managedObjectContext.fetch(reminderFetchRequest)
            if !reminder.isEmpty {
                return reminder.first
            } else {
                return nil
            }
        } catch {
            // Present a modal alert to advise that retrieval was not succesful.
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let window = appDelegate.window else { return nil}
            
            window.presentAlert(with: "Error", message: error.localizedDescription)
            return nil
        }
    }
}
