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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(using reminder: Reminder) {
        self.reminderTitleLabel?.text = reminder.title
        self.reminderAddressLabel?.text = reminder.address
    }

}
