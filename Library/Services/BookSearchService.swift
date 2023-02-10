//
//  SearchService.swift
//  Library
//
//  Created by Admin on 10/02/2023.
//

import Foundation

protocol BookSearchService {

    /// Search for books in the API.
    /// - Parameters:
    ///   - query: Query to search. Will be percent encoded if needed.
    ///   - author: author filter of the search
    /// - Returns: a list of book
    func search(query: String, author: String?) async throws -> [any APIBook]
}
