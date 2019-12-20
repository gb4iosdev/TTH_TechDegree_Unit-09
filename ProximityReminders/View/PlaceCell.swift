//
//  PlaceCell.swift
//  ProximityReminders
//
//  Created by Gavin Butler on 05-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import MapKit

class PlaceCell: UITableViewCell {
    
    func configure(using mapItem: MKMapItem) {
        self.textLabel?.text = mapItem.name
        self.detailTextLabel?.text = mapItem.address
    }

}
