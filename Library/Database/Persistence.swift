//
//  Persistence.swift
//  Library
//
//  Created by Admin on 08/02/2023.
//

import CoreData
import Dependencies

struct PersistenceController {
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
            let nsError = error as NSError
            assertionFailure("Unresolved error \(nsError), \(nsError.userInfo)")
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
                // TODO: send to a logger / firebase in order to debug if needed.
                print("Unresolved error \(error), \(error.userInfo)")
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

