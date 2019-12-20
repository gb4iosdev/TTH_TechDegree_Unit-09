//
//  ReminderCell.swift
//  ProximityReminders
//
//  Created by Gavin Butler on 10-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {
    
    @IBOutlet weak var reminderTitleLabel: UILabel!
    @IBOutlet weak var reminderAddressLabel: UILabel!
    
    func configure(using reminder: Reminder) {
        self.reminderTitleLabel?.text = reminder.title
        self.reminderAddressLabel?.text = reminder.address
    }
}
