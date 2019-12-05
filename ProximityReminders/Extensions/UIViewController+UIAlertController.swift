//
//  UIViewController+UIAlertController.swift
//  FRCExample
//
//  Created by Dennis Parussini on 28.11.19.
//  Copyright © 2019 Dennis Parussini. All rights reserved.
//

import UIKit

//I added this extension here too. I like having a way of creating an alert in the view controller I'm in much more than creating a separate window each time I need to show an alert.
extension UIViewController {
    func presentAlert(withTitle title: String?, message: String?, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: handler)
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}
