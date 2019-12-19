//
//  UIWindow.swift
//  DiaryApp
//
//  Created by Gavin Butler on 29-11-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

//Creates an extension on UIWindow so that an alert can be presented when no view controller is present.
extension UIWindow {
    var alertWindow: UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController(nibName: nil, bundle: nil)
        window.backgroundColor = UIColor.clear
        window.windowLevel = UIWindow.Level.alert
        return window
    }
    
    func presentAlert(with title: String?, message: String?, hanlder: ((UIAlertAction) -> Void)? = nil) {
        let window = alertWindow
        let rootViewController = window.rootViewController
        window.makeKeyAndVisible()
        let okAction = UIAlertAction(title: "OK", style: .default, handler: hanlder)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(okAction)
        
        guard let rootVC = rootViewController else { return }
        rootVC.present(alertController, animated: true)
    }
}
