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
    
    var context = CoreDataStack.shared.managedObjectContext
    
    var reminder: Reminder?
    
    var location: Coordinate?
    var address: String?
    var entering: Bool?
    
    //IBOutle variables
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var directionSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var mapView: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //Load the UI if we have a reminder set
        if let reminder = self.reminder {
            loadUI(with: reminder)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let coordinate = location {
            mapView.adjust(centreTo: CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude), span: 1_000, regionRadius: 100)
        }
    }

}

//MARK: - Helper Methods:

extension ReminderEditController {
    
    func loadUI(with reminder: Reminder) {
        
        //Populate the UI fields from the reminder object.
        titleTextField.text = reminder.title
        detailTextField.text = reminder.detail
        locationLabel.text = reminder.address
        //Need to add recurring/onceOnly here
        
        let coordinate = CLLocationCoordinate2DMake(reminder.location.latitude, reminder.location.longitude)
        mapView.adjust(centreTo: coordinate, span: 1_000, regionRadius: 100)
    }

}
