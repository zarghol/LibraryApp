//
//  SearchManager.swift
//  Library
//
//  Created by Admin on 10/02/2023.
//

import Foundation
import SwiftUI

/// The SearchEngine store the current search and performs actions related to the search.
final class SearchEngine: ObservableObject {
    @Published var currentSearch: String = ""
    @Published var author: AuthorToken?
    @Published var results: [String] = []

    /// This binding is used on the token search API in order to map the tokens to a single token storage related to the author.
    var tokenBinding: Binding<[AuthorToken]> {
        Binding {
            return [self.author].compactMap { $0 }
        } set: { newValue in
            self.author = newValue.first
        }
    }

    /// Create a token with the current search text and reset the text, as it is now a token.
    func addAsAuthor() {
        author = AuthorToken(author: currentSearch)
        currentSearch = ""
    }

    func search() {
        // TODO: Create suggestion in database

        // TODO: Search with API
    }
}
