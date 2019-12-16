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
    
    private let context = CoreDataStack.shared.managedObjectContext
    
    //IBOutle variables
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var recurringSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var reminder: Reminder?
    
    //Temporary variables used to create a Reminder if save is selected
    var location: Location?
    var address: String?
    var arriving: Bool?
    
    //Map constants
    let mapSpan: Double = 500
    let mapRegionRadius: Double = 50
    
    //Location Management
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set context to main context and Load the UI if we have a reminder set
        if let reminder = self.reminder {
            load(from: reminder)
        }
        
        mapView.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let location = self.location {
            let coordinate = location.asCLLocationCoordinate2D()
            print("Just about to adjust the map view - should draw a circle")
            mapView.adjust(centreTo: coordinate, span: mapSpan, regionRadius: mapRegionRadius)
        }
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        if let reminder = reminder {
            guard let title = titleTextField.text, !title.isEmpty else {
                presentAlert(withTitle: "Please enter a title for the Reminder", message: nil)
                return
            }
            
            guard let detailText = detailTextField.text, !detailText.isEmpty else {
                presentAlert(withTitle: "Please enter some detauls for the Reminder", message: nil)
                return
            }
            
            guard let location = location, let address = address, let arriving = arriving else {
                presentAlert(withTitle: "Please select a location for the Reminder", message: nil)
                return
            }
            
            reminder.title = title
            reminder.detail = detailText
            reminder.location = location
            reminder.address = address
            print("Setting Location to: \(location) for address: \(address)")
            reminder.recurring = recurringSegmentedControl.selectedSegmentIndex == 0 ? true : false
            reminder.arriving = arriving
            reminder.isActive = true
            CoreDataStack.shared.managedObjectContext.saveChanges()
            print("retrieved reminder is: \(String(describing: context.reminder(with: reminder.uuid)))")
            createGeoFenceForReminder(withID: reminder.uuid)
        } else {
            do {
                let reminderUUID = UUID()
                let arriving = self.arriving ?? true
                try Reminder.save(with: titleTextField.text, address: address, detail: detailTextField.text, recurring: recurringSegmentedControl.selectedSegmentIndex == 0 ? true : false, uuid: reminderUUID, arriving: arriving, location: location)
                print("retrieved reminder is: \(String(describing: context.reminder(with: reminderUUID)))")
                createGeoFenceForReminder(withID: reminderUUID)
            } catch {
                presentAlert(withTitle: "Error", message: error.localizedDescription)
            }
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: - PlaceSearchControllerDelegate method:
extension ReminderEditController: PlaceSearchControllerDelegate {
    func placeSearchController(_ placeSearchController: PlaceSearchController, didFinishSelectingItems mapItem: MKMapItem, arriving: Bool) {
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
        //Populate the UI fields from the reminder object.
        location = reminder.location
        address = reminder.address
        arriving = reminder.arriving
        
        titleTextField.text = reminder.title
        detailTextField.text = reminder.detail
        locationLabel.text = reminder.address
        recurringSegmentedControl.selectedSegmentIndex = reminder.recurring ? 0 : 1
        
        
    }
    
    func createGeoFenceForReminder(withID reminderID: UUID) {
        
        //Disable any geofences currently active with this ID
        
        //Load the reminder
        guard let reminder = context.reminder(with: reminderID) else { return }
        
        //Create new geofence region
        let region = CLCircularRegion(center: reminder.location.asCLLocationCoordinate2D(), radius: self.mapRegionRadius, identifier: reminder.uuid.uuidString)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        self.locationManager.startMonitoring(for: region)
        print("Now monitoring: \(region)")
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
            searchController.delegate = self
            let backItem = UIBarButtonItem()
            backItem.title = "Cancel"
            navigationItem.backBarButtonItem = backItem
        }
    }
}
