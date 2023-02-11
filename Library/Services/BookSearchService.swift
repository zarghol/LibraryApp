//
//  SearchService.swift
//  Library
//
//  Created by Admin on 10/02/2023.
//

import Foundation
import Dependencies

protocol BookSearchService: Sendable {

    /// Search for books in the API.
    /// - Parameters:
    ///   - query: Query to search. Will be percent encoded if needed.
    ///   - author: author filter of the search
    /// - Returns: a list of book
    func search(query: String, author: String?) async throws -> [any APIBook]
}

// MARK: - Dependency Definition

struct ArrayBookSearchService: BookSearchService {
    let books: [any APIBook]

    func search(query: String, author: String?) async throws -> [any APIBook] {
        return books
    }
}

private enum BookSearchServiceKey: DependencyKey {
    static let liveValue: any BookSearchService = GoogleBookSearchService()
    static let previewValue: any BookSearchService = ArrayBookSearchService(books: [])
    static let testValue: any BookSearchService = ArrayBookSearchService(books: [])
}

extension DependencyValues {
    var bookSearchService: BookSearchService {
        get { self[BookSearchServiceKey.self] }
        set { self[BookSearchServiceKey.self] = newValue }
    }
}
