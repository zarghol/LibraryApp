//
//  FavoritesService.swift
//  Library
//
//  Created by Admin on 11/02/2023.
//

import Foundation
import Dependencies

protocol FavoritesService: Sendable {
    func createFavorite(book: any APIBook, pictureData: Data?) throws

    func removeFavorite(bookIdentifier: String) throws

    func getFavorite(bookIdentifier: String) -> Book?
}

// MARK: - Dependency Definition

struct MockFavoritesService: FavoritesService {
    func createFavorite(book: any APIBook, pictureData: Data?) throws {
        // Nothing to do
    }

    func removeFavorite(bookIdentifier: String) throws {
        // Nothing to do
    }

    func getFavorite(bookIdentifier: String) -> Book? {
        return nil
    }
}

private enum FavoritesServiceKey: DependencyKey {
    static let liveValue: any FavoritesService = CoreDataFavoritesService()
    static let previewValue: any FavoritesService = MockFavoritesService()
    static let testValue: any FavoritesService = MockFavoritesService()
}

extension DependencyValues {
    var favoritesService: FavoritesService {
        get { self[FavoritesServiceKey.self] }
        set { self[FavoritesServiceKey.self] = newValue }
    }
}
