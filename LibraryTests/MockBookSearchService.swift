//
//  MockBookSearchService.swift
//  LibraryTests
//
//  Created by Admin on 10/02/2023.
//

import Foundation

@testable import Library

struct MockBookSearchService: BookSearchService {
    let books: [APIBook]

    func search(query: String, author: String?) async throws -> [APIBook] {
        return books
    }
}
