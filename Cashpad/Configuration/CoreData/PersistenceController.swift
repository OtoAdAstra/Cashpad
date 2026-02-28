//
//  PersistenceController.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 12.01.26.
//

import CoreData
import os

final class PersistenceController {

    static let shared = PersistenceController()

    let container: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "Cashpad",
        category: "CoreData"
    )

    private init() {
        container = NSPersistentContainer(name: "Cashpad")

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                Self.logger.error("Core Data failed to load: \(error), \(error.userInfo)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
}
