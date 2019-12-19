//
//  ReminderListController.swift
//  ProximityReminders
//
//  Created by Gavin Butler on 05-12-2019.
//  Attribution:  Dennis Parussini, FRCExample, 28.11.19.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class ReminderListController: UITableViewController {
    
    //Persistence:
    private let context = CoreDataStack.shared.managedObjectContext
    
    //For region deletion when reminder is deleted:
    private let locationManager = CLLocationManager()
    
    //FetchedResultsController
    private let remindersFetchedResultsController = NSFetchedResultsController(fetchRequest: Reminder.remindersFetchRequest(), managedObjectContext: CoreDataStack.shared.managedObjectContext, sectionNameKeyPath: #keyPath(Reminder.isActive), cacheName: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.title = "My Reminders"
        
        remindersFetchedResultsController.delegate = self
        
        //Load the fetched results controller
        do {
            try remindersFetchedResultsController.performFetch()
        } catch {
            presentAlert(withTitle: "Error:", message: error.localizedDescription)
        }
    }
}

//MARK: - TableView datasoure and delegate methods:
extension ReminderListController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return remindersFetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return remindersFetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as? ReminderCell else { return UITableViewCell() }
        
        let reminder = remindersFetchedResultsController.object(at: indexPath)
        
        //Configuration defined in ReminderCell class:
        cell.configure(using: reminder)
        
        return cell
    }
    
    //Segregate active and inactive reminders
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0: return "Active"
            default: return "inActive"
        }
    }
    
    //Allow swipe to delete on the tableView rows
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let reminder = remindersFetchedResultsController.object(at: indexPath)
            //Delete this reminder's region before deleting the reminder
            for region in locationManager.monitoredRegions {
                if region.identifier == reminder.uuid.uuidString {
                    locationManager.stopMonitoring(for: region)
                }
            }
            context.delete(reminder)
            context.saveChanges()
        }
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension ReminderListController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.performUpdates(for: controller, type: type, indexPath: indexPath, newIndexPath: newIndexPath)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    //Allows sections to respond to changes in data
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: tableView.insertSections(indexSet, with: .automatic)
        case .delete: tableView.deleteSections(indexSet, with: .automatic)
        default: break
        }
    }
}

//MARK: - Segues

extension ReminderListController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Should only be segueing to the edit ViewController here.
        guard let editViewController = segue.destination as? ReminderEditController else { return }
        
        if segue.identifier == "EditReminder", let selectedRow = self.tableView.indexPathForSelectedRow {
            //if we have a selected row, set the reminder for the edit view controller
            let reminder = remindersFetchedResultsController.object(at: selectedRow)
            editViewController.reminder = reminder
        }
    }
}
