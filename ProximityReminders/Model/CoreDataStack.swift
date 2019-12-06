//
//  CoreDataStack.swift
//  DiaryApp
//
//  Created by Gavin Butler on 26-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit
import CoreData

//Marking all classes you won't subclass (even the AppDelegate) as "final" makes your code safer (no one else will be able to subclass it) and Swift will perform some performance enhancements.
final class CoreDataStack {
    private init() {}
    
    //Having a shared context (singleton) helps us use the same context across our entire app without passing it around all the time.
    static let shared = CoreDataStack()

    lazy var managedObjectContext: NSManagedObjectContext = {
        let container = self.persistentContainer
        return container.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer  = {
        let container = NSPersistentContainer (name: "DiaryList")
        container.loadPersistentStores() { storeDescription, error in
            if let error = error as NSError? {
                
                //Inform the user of the failure to load from persisent store, then terminate the app
                DispatchQueue.main.async {
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let window = appDelegate.window else { return }
                    
                    
                    //Call the presentAlert method from your UIWindow extension
                    window.presentAlert(with: "Error", message: error.localizedDescription)
                    
                    fatalError("Error:  Unknown type: \(error), \(error.localizedDescription)")
                }
            }
        }
        return container
    }()
    
}

extension NSManagedObjectContext {
    
    func saveChanges() {
        if self.hasChanges {
            do {
                try save()
            } catch {
                // Present a modal alert to advise that save was not succesful.
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let window = appDelegate.window else { return }
                
                window.presentAlert(with: "Error", message: error.localizedDescription)
            }
        }
    }
}
