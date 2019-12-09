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

class ReminderListController: UITableViewController {
    
    //MARK: - NSFetchedResultsController
    private let remindersFetchedResultsController = NSFetchedResultsController(fetchRequest: Reminder.remindersFetchRequest(), managedObjectContext: CoreDataStack.shared.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.title = "My Reminders"
        
        remindersFetchedResultsController.delegate = self
        
        do {
            try remindersFetchedResultsController.performFetch()
        } catch {
            presentAlert(withTitle: "Error:", message: error.localizedDescription)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return remindersFetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath)
        cell.textLabel?.text = remindersFetchedResultsController.object(at: indexPath).title
        return cell
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
}

//MARK: - Segues

extension ReminderListController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Should only be segueing to the edit VC here.
        guard let editViewController = segue.destination as? ReminderEditController else { return }
        
        if segue.identifier == "EditReminder", let selectedRow = self.tableView.indexPathForSelectedRow {   //Need to set the reminder
            let reminder = remindersFetchedResultsController.object(at: selectedRow)
            editViewController.reminder = reminder
        }
    }
}
