//
//  ReminderEditController.swift
//  ProximityReminders
//
//  Created by Gavin Butler on 05-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ReminderEditController: UIViewController {
    
    var context = CoreDataStack.shared.managedObjectContext
    var reminder: Reminder?
    
    //Temporary variables used to create a Reminder if save is selected
    var location: Location?
    var address: String?
    var arriving: Bool?
    
    //Map constants
    let mapSpan: Double = 1_000
    let mapRegionRadius: Double = 100
    
    //IBOutle variables
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var recurringSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var mapView: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //Set context to main context and Load the UI if we have a reminder set
        if let reminder = self.reminder {
            load(from: reminder)
        }
        
        mapView.delegate = self
        
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        //Input Validation
        guard !titleTextField.text!.isEmpty else {
            presentAlert(withTitle: "Please enter a title for the Reminder", message: nil)
            return
        }
        guard let location = self.location, let address = self.address, let arriving = self.arriving else {
            presentAlert(withTitle: "Please select a location for the Reminder", message: nil)
            return
        }
        
        if self.reminder == nil {    //If we have a nil reminder we have been dealing with a temporary object & need to create a new one
            print("Creating a new reminder")
            let reminder = Reminder(context: context)
            reminder.uuid = UUID().uuidString
            reminder.creationDate = Date() as NSDate
            self.reminder = reminder
        }
        
        
        reminder?.title = titleTextField.text!
        reminder?.detail = detailTextField.text
        reminder?.recurring = recurringSegmentedControl.selectedSegmentIndex  == 0
        reminder?.location = location
        reminder?.address = address
        reminder?.arriving = arriving
        print("reminder is: \(reminder!)")
        
        //Data persistence
        context.saveChanges()
        

        print("Confirming saved from Reminder Edit Controller")
        
        navigationController?.popToRootViewController(animated: true)

    }
    

}

//MARK: - PlaceSaverDelegate method:
extension ReminderEditController: PlaceSaverDelegate {
    
    func saveItems(_ mapItem: MKMapItem, arriving: Bool) {
        
        if let location2D = mapItem.placemark.location?.coordinate {
            print("Saving items from PlaceSearchController now")
            self.location = Location.fromCLLocationCoordinate2D(coordinate2d: location2D)
            mapView.adjust(centreTo: location2D, span: self.mapSpan, regionRadius: self.mapRegionRadius)
        }
        
        self.address = mapItem.address
        locationLabel.text = mapItem.address
        
        self.arriving = arriving
    }
    
    
}

//MARK: - Helper Methods:

extension ReminderEditController {
    
    func load(from reminder: Reminder) {
        
        //Assign to local variables where appropriate:
        self.location = reminder.location
        self.address = reminder.address
        self.arriving = reminder.arriving
        
        //Populate the UI fields from the reminder object.
        titleTextField.text = reminder.title
        detailTextField.text = reminder.detail
        locationLabel.text = reminder.address
        recurringSegmentedControl.selectedSegmentIndex = reminder.recurring ? 0 : 1
        
        let coordinate = CLLocationCoordinate2DMake(reminder.location.latitude, reminder.location.longitude)
        mapView.adjust(centreTo: coordinate, span: 1_000, regionRadius: 100)
    }

}

//  MARK: - Map Delegate methods
extension ReminderEditController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return mapView.renderer(for: overlay)
    }
}

//MARK: - Segues

extension ReminderEditController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Set the delegate to allow for saving
        if segue.identifier == "ShowSearch", let searchController = segue.destination as? PlaceSearchController {
            searchController.saverDelegate = self
            let backItem = UIBarButtonItem()
            backItem.title = "Cancel"
            navigationItem.backBarButtonItem = backItem
        }
    }
}
