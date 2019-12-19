//
//  UIViewController+UIAlertController.swift
//  FRCExample
//
//  Created by Dennis Parussini on 28.11.19.
//  Copyright © 2019 Dennis Parussini. All rights reserved.
//

import UIKit

//Create an alert in the view controller.
extension UIViewController {
    func presentAlert(withTitle title: String?, message: String?, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: handler)
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}
