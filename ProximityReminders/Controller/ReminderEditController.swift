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
    
    //Persistence:
    private let context = CoreDataStack.shared.managedObjectContext
    
    //IBOutlet variables
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var recurringSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var mapView: MKMapView!
    
    //Key variable for the class:
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

        //Load the class & UI if we have a reminder set
        if let reminder = self.reminder {
            load(from: reminder)
        }
        
        //Let this view controller respond to map view delegate calls
        mapView.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //If we have a location, center the map and draw a circle
        if let location = self.location {
            let coordinate = location.asCLLocationCoordinate2D()
            mapView.adjust(centreTo: coordinate, span: mapSpan, regionRadius: mapRegionRadius)
        }
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        //If we have a reminder, and from the UI we have title, detail and location populated:
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
            
            //Assign to reminder properties, save & create the geoFence region:
            reminder.title = title
            reminder.detail = detailText
            reminder.location = location
            reminder.address = address
            reminder.recurring = recurringSegmentedControl.selectedSegmentIndex == 0 ? true : false
            reminder.arriving = arriving
            reminder.isActive = true
            CoreDataStack.shared.managedObjectContext.saveChanges()
            createGeoFenceForReminder(withID: reminder.uuid)
            
        } else {    //We are creating a new reminder, saving & creating a geofence
            do {
                let reminderUUID = UUID()
                let arriving = self.arriving ?? true
                try Reminder.save(with: titleTextField.text, address: address, detail: detailTextField.text, recurring: recurringSegmentedControl.selectedSegmentIndex == 0 ? true : false, uuid: reminderUUID, arriving: arriving, location: location)
                createGeoFenceForReminder(withID: reminderUUID)
            } catch {
                presentAlert(withTitle: "Error", message: error.localizedDescription)
            }
        }
        
        //Return to reminderListController
        navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: - PlaceSearchControllerDelegate method:
extension ReminderEditController: PlaceSearchControllerDelegate {
    
    func placeSearchController(_ placeSearchController: PlaceSearchController, didFinishSelectingItems mapItem: MKMapItem, arriving: Bool) {
        //If a co-ordinate is available in the MKMapItem for the selected location, create the location, adjust the map view and set other reminder properties.
        if let location2D = mapItem.placemark.location?.coordinate {
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
        //Populate variables from the reminder object.
        location = reminder.location
        address = reminder.address
        arriving = reminder.arriving
        
        //Populate UI fields from the reminder object.
        titleTextField.text = reminder.title
        detailTextField.text = reminder.detail
        locationLabel.text = reminder.address
        recurringSegmentedControl.selectedSegmentIndex = reminder.recurring ? 0 : 1
    }
    
    func createGeoFenceForReminder(withID reminderID: UUID) {
        
        //Load the reminder
        guard let reminder = context.reminder(with: reminderID) else { return }
        
        //Create new geofence region
        let region = CLCircularRegion(center: reminder.location.asCLLocationCoordinate2D(), radius: self.mapRegionRadius, identifier: reminder.uuid.uuidString)
        region.notifyOnEntry = reminder.arriving
        region.notifyOnExit = !reminder.arriving
        self.locationManager.startMonitoring(for: region)
    }
}

//  MARK: - Map Delegate methods
extension ReminderEditController: MKMapViewDelegate {
    //Required to draw on the map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return mapView.renderer(for: overlay)
    }
}

//MARK: - Segues

extension ReminderEditController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Set the delegate to allow for saving of the location
        if segue.identifier == "ShowSearch", let searchController = segue.destination as? PlaceSearchController {
            searchController.delegate = self
            let backItem = UIBarButtonItem()
            backItem.title = "Cancel"
            navigationItem.backBarButtonItem = backItem
        }
    }
}
