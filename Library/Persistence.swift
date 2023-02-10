//
//  Persistence.swift
//  Library
//
//  Created by Admin on 08/02/2023.
//

import CoreData
import Dependencies

struct PersistenceController {
    static let shared = PersistenceController()

    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Book(context: viewContext)
            newItem.title = UUID().uuidString
            newItem.author = UUID().uuidString
        }

        let search1 = Search(context: viewContext)
        search1.timestamp = Date()
        search1.query = "The Burning White"
        search1.author = "Brent Weeks"

        let search2 = Search(context: viewContext)
        search2.timestamp = Date()
        search2.query = "The Blood Mirror"

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            // For now I don't want to fatalError, or handle the error as the model is still changing
            print("Unresolved error \(nsError), \(nsError.userInfo)")
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Library")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
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
                // For now I don't want to fatalError, or handle the error as the model is still changing
                print("Unresolved error \(error), \(error.userInfo)")
//                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

// MARK: - Dependency Definition

private enum PersistenceKey: DependencyKey {
    static let liveValue = PersistenceController()
    static let previewValue = PersistenceController.preview
    static let testValue = PersistenceController(inMemory: true)
}

extension DependencyValues {
    var persistence: PersistenceController {
        get { self[PersistenceKey.self] }
        set { self[PersistenceKey.self] = newValue }
    }
}

