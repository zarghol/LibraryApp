//
//  LibraryApp.swift
//  Library
//
//  Created by Admin on 08/02/2023.
//

import SwiftUI

@main
struct LibraryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
