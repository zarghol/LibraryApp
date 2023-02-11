//
//  SearchManager.swift
//  Library
//
//  Created by Admin on 10/02/2023.
//

import Foundation
import SwiftUI
import Dependencies

/// The SearchEngine store the current search and performs actions related to the search.
final class SearchEngine: ObservableObject {

    // MARK: Dependencies

    @Dependency(\.bookSearchService) var searchService
    @Dependency(\.suggestionsService) var suggestionsService

    // MARK: - Properties

    @Published var currentSearch: String = ""
    @Published var author: AuthorToken?
    @Published var results: [any APIBook] = []

    /// This binding is used on the token search API in order to map the tokens to a single token storage related to the author.
    var tokenBinding: Binding<[AuthorToken]> {
        Binding {
            return [self.author].compactMap { $0 }
        } set: { newValue in
            self.author = newValue.first
        }
    }

    // MARK: - API

    /// Create a token with the current search text and reset the text, as it is now a token.
    func addAsAuthor() {
        author = AuthorToken(author: currentSearch)
        currentSearch = ""
    }

    /// Search the query composed of ``currentSearch`` and ``author`` through the API exposed in the ``searchService``.
    ///
    /// The method start an asynchronous process, that will be ended by updating the ``results``.
    /// - Parameter isFromSuggestion: if `true`, doesn't add the query to the suggestions, in order to not duplicates suggestions.
    func search(isFromSuggestion: Bool) {
        Task(priority: .userInitiated) { @MainActor [weak self] in
            guard let self else { return }
            do {
                self.results = try await self.searchService.search(query: self.currentSearch, author: self.author?.author)
                if !isFromSuggestion {
                    try self.suggestionsService.createSuggestion(query: self.currentSearch, author: self.author?.author)
                }

            } catch {
                // TODO: send to a logger / firebase in order to debug if needed.
                print("error : \(error)")
            }
        }
    }

    /// Replace the current query by a suggestion and immediately search it.
    func apply(_ suggestion: Search) {
        self.currentSearch = suggestion.query
        self.author = suggestion.author.map(AuthorToken.init(author:))

        self.search(isFromSuggestion: true)
    }

    /// Invalidate the current content of ``results``. Useful when after a search, the result is displayed and we want to do another search. The results is no longer pertinent and thus, removed.
    func invalidateResults() {
        results = []
    }

    /// Clear the content of the suggestions list.
    func clearSuggestions() {
        do {
            try suggestionsService.removeAll()
        } catch {
            print("error : \(error)")
        }
    }
}
