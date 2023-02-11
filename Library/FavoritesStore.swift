//
//  FavoritesStore.swift
//  Library
//
//  Created by Admin on 11/02/2023.
//

import Foundation
import Dependencies

final class FavoritesStore: ObservableObject {
    @Dependency(\.favoritesService) var favoritesService

    func addFavorite(book: any APIBook) async throws {
        let (data, _) = try await URLSession.shared.data(from: book.imageURL)

        try favoritesService.createFavorite(book: book, pictureData: data)
    }

    func removeFavorite(bookIdentifier: String) throws {
        try favoritesService.removeFavorite(bookIdentifier: bookIdentifier)
    }

    func isFavorite(bookIdentifier: String) -> Bool {
        favoritesService.getFavorite(bookIdentifier: bookIdentifier) != nil
    }
}
