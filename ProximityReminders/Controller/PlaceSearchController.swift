//
//  PlaceSearchController.swift
//  ProximityReminders
//
//  Created by Gavin Butler on 01-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit
import MapKit

class PlaceSearchController: UIViewController {
    
    weak var delegate: PlaceSearchControllerDelegate?
    
    //Outlet variables
    @IBOutlet weak var placesTableView: UITableView!
    @IBOutlet weak var directionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    
    //Datasource for search
    var filteredData: [MKMapItem] = []
    
    //Location related variables
    var chosenPlace: MKMapItem?
    var defaultRegion: MKCoordinateRegion?
    
    //Search related variables
    let searchController = UISearchController(searchResultsController: nil)
    let searchRequest = MKLocalSearch.Request()
    
    //Map constants
    let mapSpan: Double = 400
    let mapRegionRadius: Double = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesTableView.dataSource = self
        placesTableView.delegate = self
        
        directionSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .normal)
        directionSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
        
        mapView.delegate = self
        
        configureSearchController()
        configureUI()
        
        defaultRegion = mapView.region
    }
    
    //If we have selected a place in the tableview, capture the corresponding MKMapItem and arriving/departing setting and save back to the delegate (ReminderEditController).  Otherwise alert the user to no location being set.
    @IBAction func saveLocationButtonPressed(_ sender: UIBarButtonItem) {
        if let chosenPlace = self.chosenPlace {
            let arriving = directionSegmentedControl.selectedSegmentIndex == 0
            delegate?.placeSearchController(self, didFinishSelectingItems: chosenPlace, arriving: arriving)
            self.navigationController?.popViewController(animated: true)
        } else {
            self.presentAlert(withTitle: "Please select a location to save", message: nil)
        }
    }
    
    
}

//  MARK: - Table View Datasource methods
extension PlaceSearchController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell") as? PlaceCell else { return UITableViewCell() }
        
        cell.configure(using: filteredData[indexPath.row])
        
        return cell
    }
}

//  MARK: - Table View Delegate methods
extension PlaceSearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let coordinate = filteredData[indexPath.row].placemark.location?.coordinate {
            //Capture the selection to be ready for saving:
            chosenPlace = filteredData[indexPath.row]
            
            //Adjust the map to reflect the chosen place:
            mapView.adjust(centreTo: coordinate, span: mapSpan, regionRadius: mapRegionRadius)
        }
    }
}

//  MARK: - Search Controller methods
extension PlaceSearchController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        //If there is text, use it as the filter
        if !searchController.searchBar.text!.isEmpty {
            searchRequest.naturalLanguageQuery = searchController.searchBar.text!
            searchRequest.region = mapView.region
            
            let search = MKLocalSearch(request: searchRequest)
            
            search.start { response, error in
                if let response = response {
                    //If we have a valid response, extract the MKMapItems, and execute tableview reload on main queue.
                    self.filteredData = response.mapItems
                    DispatchQueue.main.async {
                        self.placesTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //On cancel, reset the map and erase all table view items.
        if let defaultRegion = self.defaultRegion {
            mapView.setRegion(defaultRegion, animated: true)
        }
        filteredData = []
        placesTableView.reloadData()
    }
}

//  MARK: - Map Delegate methods
extension PlaceSearchController: MKMapViewDelegate {
    //Required to draw on the map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return mapView.renderer(for: overlay)
    }
}

//  MARK: - Helper methods
extension PlaceSearchController {
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Places"
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.delegate = self
    }
    
    //Basic UI Setup for this view controller
    func configureUI() {
        self.navigationItem.rightBarButtonItem?.title = "Save Location"
    }
}
