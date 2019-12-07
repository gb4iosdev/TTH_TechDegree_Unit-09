//
//  ReminderEditController.swift
//  ProximityReminders
//
//  Created by Gavin Butler on 05-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit
import MapKit

class ReminderEditController: UIViewController {
    
    let context = CoreDataStack.shared.managedObjectContext
    
    var reminder: Reminder?
    
    //IBOutle variables
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var recurringSegmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var mapView: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //Load the UI if we have a reminder set
        if let reminder = self.reminder {
            updateUI(with: reminder)
        } else {    //Otherwise create a blank one
            self.reminder = Reminder(context: context)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let location = reminder?.location {
            mapView.adjust(centreTo: location.asCLLocationCoordinate2D(), span: 1_000, regionRadius: 100)
        }
    }

}

//MARK: - PlaceSaverDelegate method:
extension ReminderEditController: PlaceSaverDelegate {
    
    func saveItems(_ mapItem: MKMapItem, arriving: Bool) {
        print("Saving items now")
        if let location2D = mapItem.placemark.location?.coordinate {
            reminder?.location = Location.fromCLLocationCoordinate2D(coordinate2d: location2D)
        }
        
        reminder?.address = mapItem.address
        reminder?.arriving = arriving
        
        updateUI(with: self.reminder!)
    }
    
    
}

//MARK: - Helper Methods:

extension ReminderEditController {
    
    func updateUI(with reminder: Reminder) {
        
        //Populate the UI fields from the reminder object.
        titleTextField.text = reminder.title
        detailTextField.text = reminder.detail
        locationLabel.text = reminder.address
        //Need to add recurring/onceOnly here
        
        let coordinate = CLLocationCoordinate2DMake(reminder.location.latitude, reminder.location.longitude)
        mapView.adjust(centreTo: coordinate, span: 1_000, regionRadius: 100)
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
