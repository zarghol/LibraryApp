//
//  LibraryApp.swift
//  Library
//
//  Created by Admin on 08/02/2023.
//

import SwiftUI
import Dependencies
@main
struct LibraryApp: App {
    @Dependency(\.persistence) var persistence

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }
}
