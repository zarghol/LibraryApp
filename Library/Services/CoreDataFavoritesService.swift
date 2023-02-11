//
//  CoreDataFavoritesService.swift
//  Library
//
//  Created by Admin on 11/02/2023.
//

import Foundation
import CoreData
import Dependencies

final class CoreDataFavoritesService: FavoritesService {
    @Dependency(\.persistence.container.viewContext) var context

    func createFavorite(book: any APIBook, pictureData: Data?) throws {
        let newBook = Book(context: context)
        newBook.identifier = book.id
        newBook.author = book.authors.first
        newBook.title = book.title
        newBook.desc = book.description
        newBook.picture = pictureData

        try context.save()
    }

    func removeFavorite(bookIdentifier: String) throws {
        let fetchRequest = Book.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", bookIdentifier)
        fetchRequest.fetchLimit = 1
        let fetchedArray = try context.fetch(fetchRequest)

        guard let book = fetchedArray.first else {
            return
        }

        context.delete(book)

        try context.save()
    }

    func getFavorite(bookIdentifier: String) -> Book? {
        let fetchRequest = Book.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", bookIdentifier)
        fetchRequest.fetchLimit = 1
        let fetchedArray = try? context.fetch(fetchRequest)
        return fetchedArray?.first
    }
}
