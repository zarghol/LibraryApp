//
//  MockFavoritesService.swift
//  LibraryTests
//
//  Created by Admin on 11/02/2023.
//

import Foundation
import Dependencies

@testable import Library

final class MockFavoritesService: FavoritesService {
    var createdBook: MockAPIBook?
    var createdWithPicture: Bool?
    var removedIdentifier: String?
    var fetchedIdentifier: String?

    func createFavorite(book: APIBook, pictureData: Data?) throws {
        // Nothing to do
        createdBook = book as? MockAPIBook
        createdWithPicture = pictureData != nil
    }

    func removeFavorite(bookIdentifier: String) throws {
        removedIdentifier = bookIdentifier
    }

    func getFavorite(bookIdentifier: String) -> Book? {
        fetchedIdentifier = bookIdentifier
        return nil
    }
}
