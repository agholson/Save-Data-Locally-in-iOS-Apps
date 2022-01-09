//
//  Persistence.swift
//  Shared
//
//  Created by Leone on 1/9/22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    // Used for previews within the app
    static var preview: PersistenceController = {
        // Uses inMemory flag, so the objects are not truly added to the data store
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            // Create dummy persons
            let newItem = Person(context: viewContext)
            // Set name to Sam
            newItem.name = "Sam"
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    private init(inMemory: Bool = false) {
        // Create a new NSPersistentContainer with the following name
        container = NSPersistentContainer(name: "Core_Data_Demo")
        // If inMemory is true, then don't save it to the Core Data persistence container
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // Attempts to load data from the Core_Data_Demo container
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
