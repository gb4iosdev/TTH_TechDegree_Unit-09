//
//  PlaceCell.swift
//  ProximityReminders
//
//  Created by Gavin Butler on 05-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import MapKit

class PlaceCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(using mapItem: MKMapItem) {
        self.textLabel?.text = mapItem.name
        
        //Build street address
        let placemark = mapItem.placemark
        let number = placemark.subThoroughfare ?? ""
        let street = placemark.thoroughfare ?? ""
        let city = placemark.locality ?? ""
        let country = placemark.country ?? ""
        self.detailTextLabel?.text = "\(number) \(street), \(city), \(country)"
    }

}
