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
    
    private let context = CoreDataStack.shared.managedObjectContext
    private let locationManager = CLLocationManager()
    
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
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        //locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        print("Number of Regions monitored is: \(locationManager.monitoredRegions.count)")
    }
}

//MARK: - TableView datasoure and delegate methods:
extension ReminderListController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return remindersFetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as? ReminderCell else { return UITableViewCell() }
        
        let reminder = remindersFetchedResultsController.object(at: indexPath)
        cell.configure(using: reminder)
        
        return cell
    }
    
    //Allow swipe to delete on the tableView rows
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let reminder = remindersFetchedResultsController.object(at: indexPath)
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
}

//  MARK: - Location Manager Delegate methods
extension ReminderListController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entering Region: \(region)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exiting Region: \(region)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("User current location is: \(location)")
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
