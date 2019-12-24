//
//  ReminderTextView.swift
//  ProximityReminders
//
//  Created by Gavin Butler on 24-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

//Subclassing UITextView to provide placeholder behaviour in the reminder detail text view
class ReminderTextView: UITextView {

    private let placeHolderTextColour = UIColor(displayP3Red: 102/255, green: 162/255, blue: 195/255, alpha: 1.0)
    private let editingColour = UIColor.white
    private let placeholderText = "Enter extra notes here"
    
    //Set the placeholder text colour and actual text in the text view
    func setPlaceholder() {
        self.textColor = placeHolderTextColour
        self.text = placeholderText
    }
    
    //Configure for editing
    func setForEditing(withIntialText text: String) {
        self.textColor = editingColour
        self.text = text
    }
    
    //Returns true if the existing text is all placeholder text
    var placeholderRemoved: Bool {
        return self.text! !=  placeholderText
    }
}
