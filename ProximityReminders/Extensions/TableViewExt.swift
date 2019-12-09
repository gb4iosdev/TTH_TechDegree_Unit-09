//
//  TableViewExt.swift
//  DiaryApp
//
//  Created by Gavin Butler on 02-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit
import CoreData

extension UITableView {
    func performUpdates(for controller: NSFetchedResultsController<NSFetchRequestResult>, type: NSFetchedResultsChangeType, indexPath: IndexPath?, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else { return }
            deleteRows(at: [indexPath], with: .automatic)
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
            deleteRows(at: [oldIndexPath], with: .automatic)
            insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            reloadRows(at: [indexPath], with: .automatic)
        @unknown default: break
        }
    }
}
