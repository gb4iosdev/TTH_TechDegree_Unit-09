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
    
    var saverDelegate: PlaceSaverDelegate?
    
    @IBOutlet weak var placesTableView: UITableView!
    @IBOutlet weak var directionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    
    
    var filteredData: [MKMapItem] = []
    var chosenPlace: MKMapItem?
    let searchController = UISearchController(searchResultsController: nil)
    let searchRequest = MKLocalSearch.Request()
    
    var defaultRegion: MKCoordinateRegion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesTableView.dataSource = self
        placesTableView.delegate = self
        
        mapView.delegate = self
        
        configureSearchController()
        configureUI()
        
        defaultRegion = mapView.region
        
        
    }
    
    @IBAction func saveLocationButtonPressed(_ sender: UIBarButtonItem) {
        if let chosenPlace = self.chosenPlace {
            let arriving = directionSegmentedControl.selectedSegmentIndex == 0
            saverDelegate?.saveItems(chosenPlace, arriving: arriving)
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
            mapView.adjust(centreTo: coordinate, span: 500, regionRadius: 100)
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
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circleOverlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: circleOverlay)
            //circleRenderer.fillColor?.withAlphaComponent(0.1)
            circleRenderer.fillColor = .cyan
            circleRenderer.strokeColor = .black
            //circleRenderer.strokeColor?.withAlphaComponent(0.8)
            circleRenderer.lineWidth = 2.0
            circleRenderer.alpha = 0.3
            
            
            return circleRenderer
        } else {
            return MKOverlayRenderer()
        }
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
        //self.navigationController?.navigationBar.topItem?.title = "Cancel"
        self.navigationItem.rightBarButtonItem?.title = "Save Location"
    }
}
