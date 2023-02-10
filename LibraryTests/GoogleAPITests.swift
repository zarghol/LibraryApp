//
//  GoogleAPITests.swift
//  LibraryTests
//
//  Created by Admin on 10/02/2023.
//

import XCTest

@testable import Library

final class GoogleAPITests: XCTestCase {

    let service = GoogleBookSearchService()

    func testSearchNoAuthor() async throws {
        try await XCTTry {
            let books = try await service.search(query: "test", author: nil)

            XCTAssertFalse(books.isEmpty)
        }
    }

    func testSearchWithAuthor() async throws {
        try await XCTTry {
            let books = try await service.search(query: "test", author: "a")

            XCTAssertFalse(books.isEmpty)
        }
    }

    func testSearchNoResults() async throws {
        try await XCTTry {
            let books = try await service.search(query: "bbbbb", author: "aaaaa")

            XCTAssertTrue(books.isEmpty)
        }
    }

    // TODO: add more tests with local json, in order to test the local implementation, not the current web API.
}
