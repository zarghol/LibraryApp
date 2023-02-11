//
//  CoreDataSuggestionsService.swift
//  Library
//
//  Created by Admin on 10/02/2023.
//

import Foundation
import CoreData
import Dependencies

final class CoreDataSuggestionsService: SuggestionsService {
    @Dependency(\.persistence.container.viewContext) var context

    func createSuggestion(query: String, author: String?) throws {
        let newSuggestion = Search(context: context)
        newSuggestion.query = query
        newSuggestion.timestamp = Date()
        newSuggestion.author = author

        try context.save()
    }

    func removeAll() throws {
        let deleteRequest = NSBatchDeleteRequest.init(fetchRequest: Search.fetchRequest())
        try context.persistentStoreCoordinator?.execute(deleteRequest, with: context)
    }
}
