//
//  FavoritesStore.swift
//  Library
//
//  Created by Admin on 11/02/2023.
//

import Foundation
import Dependencies

/// Object useful to interrogate the ``favoritesService`` from the ViewModel / View point of view.
///
/// Allows to manipulate favorites entities.
final class FavoritesStore: ObservableObject {

    // MARK: Dependencies

    @Dependency(\.favoritesService) var favoritesService
    @Dependency(\.urlSession) var urlSession

    // MARK: - API

    /// Add a searched book to the user favorites.
    ///
    ///  > warning: Will fetch the image through ``urlSession`` in order to save it.
    /// - Parameter book: The book fetched from the API.
    func addFavorite(book: any APIBook) async throws {
        let data: Data?
        if let imageUrl = book.imageURL {
            // We don't want to fail the creation if only the image is missing.
            let result = try? await urlSession.data(from: imageUrl)
            data = result?.0
        } else {
            data = nil
        }

        try favoritesService.createFavorite(book: book, pictureData: data)
    }

    /// Remove a book from the user favorites.
    /// - Parameter bookIdentifier: The identifier of the book to remove.
    func removeFavorite(bookIdentifier: String) throws {
        try favoritesService.removeFavorite(bookIdentifier: bookIdentifier)
    }

    /// `true` if the book is already saved as favorites, `false` otherwise.
    /// - Parameter bookIdentifier: The identifier of the book to check.
    func isFavorite(bookIdentifier: String) -> Bool {
        favoritesService.getFavorite(bookIdentifier: bookIdentifier) != nil
    }
}
