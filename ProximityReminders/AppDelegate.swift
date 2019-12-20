//
//  AppDelegate.swift
//  ProximityReminders
//
//  Created by Gavin Butler on 01-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //Persistence:
    private let context = CoreDataStack.shared.managedObjectContext
    
    //The location manager object does not have to be a singleton.  Instances in other classes will have access to the same central Location Manager.
    private let locationManager = CLLocationManager()
    // assign the current notification centre singleton
    private var notificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // register the Notification Centre's delegate, authorize for notifications & set notification options (location manager authorization done here also)
        notificationCenter.delegate = self
        configureNotificationCentre()
        
        // Set the locationManagers’s delegate to this AppDelegate class & start monitoring.
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        context.saveChanges()
    }

}

//MARK: - Region Monitoring delegate and helper methods:
extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        //Use the region identifier to retrieve the Reminder object:
        guard let reminderUUID = UUID(uuidString: region.identifier), let reminder = Reminder.with(uuid: reminderUUID) else { return }
        
        //Check if the reminder is for entering
        guard reminder.arriving else { return }
        
        //Fire the notification set reminder to inactive if required
        executeNotification(for: reminder, in: region, manager: manager)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {

        //Use the region identifier to retrieve the Reminder object:
        guard let reminderUUID = UUID(uuidString: region.identifier), let reminder = Reminder.with(uuid: reminderUUID) else { return }
        
        //Check if the reminder is for exiting
        guard !reminder.arriving else { return }
        
        //Fire the notification set reminder to inactive if required
        executeNotification(for: reminder, in: region, manager: manager)
    }
    
    func executeNotification(for reminder: Reminder, in region: CLRegion, manager: CLLocationManager) {
        
        //Create and execute the notification based on Reminder
        self.notificationCenter.notifyUsingReminder(reminder)
        
        //Remove the region monitoring if this is not a recurring reminder and set it's flag to non-active
        if !reminder.recurring {
            manager.stopMonitoring(for: region)
            reminder.isActive = false
            context.saveChanges()
        }
    }
}

//MARK: - Notification delegate and helper methods
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    //Makes notification appear even if the app is in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    func configureNotificationCentre() {
        
        // set options for authorization request
        let options: UNAuthorizationOptions = [.alert, .sound]
        
        // request permission - location manager authorization also
        notificationCenter.requestAuthorization(options: options) { (granted, error) in
            if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            }
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
}


