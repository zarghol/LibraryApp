//
//  FavoriteStoreTests.swift
//  LibraryTests
//
//  Created by Admin on 11/02/2023.
//

import XCTest
import Combine
import Dependencies

@testable import Library

final class FavoriteStoreTests: XCTestCase {
    func testAddFavorite() async throws {
        let book = MockAPIBook(
            id: "id",
            url: URL(string: "https://")!,
            title: "test book",
            authors: ["author 1"],
            description: "description",
            imageURL: URL(string: "https://books.google.com/books/publisher/content?id=dRKHAQAAQBAJ&printsec=frontcover&img=1&zoom=1")!
        )

        let mockService = MockFavoritesService()
        let store = withDependencies {
            $0.favoritesService = mockService
        } operation: {
            FavoritesStore()
        }

        try await store.addFavorite(book: book)

        XCTAssertEqual(mockService.createdBook, book)
    }

    func testRemove() throws {
        let identifier = "id"

        let mockService = MockFavoritesService()
        let store = withDependencies {
            $0.favoritesService = mockService
        } operation: {
            FavoritesStore()
        }

        try store.removeFavorite(bookIdentifier: identifier)

        XCTAssertEqual(mockService.removedIdentifier, identifier)
    }

    func testIsFavorite() {
        let identifier = "id"

        let mockService = MockFavoritesService()
        let store = withDependencies {
            $0.favoritesService = mockService
        } operation: {
            FavoritesStore()
        }

        let isFavorite = store.isFavorite(bookIdentifier: identifier)

        XCTAssertFalse(isFavorite)
        XCTAssertEqual(mockService.fetchedIdentifier, identifier)
    }
}
