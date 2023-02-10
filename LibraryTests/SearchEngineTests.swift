//
//  SearchEngineTests.swift
//  LibraryTests
//
//  Created by Admin on 10/02/2023.
//

import XCTest
import Combine
import Dependencies

@testable import Library

final class SearchEngineTests: XCTestCase {
    func testInitialState() {
        let searchEngine = withDependencies {
            $0.bookSearchService = ArrayBookSearchService(
                books: [
                    MockAPIBook(title: "test")
                ]
            )
        } operation: {
            SearchEngine()
        }

        XCTAssertTrue(searchEngine.results.isEmpty)
        XCTAssertNil(searchEngine.author)
        XCTAssertTrue(searchEngine.tokenBinding.wrappedValue.isEmpty)
        XCTAssertEqual(searchEngine.currentSearch, "")
        
    }

    func testSearch() async throws {
        let book = MockAPIBook(title: "test")

        let searchEngine = withDependencies {
            $0.bookSearchService = ArrayBookSearchService(
                books: [
                    book
                ]
            )
        } operation: {
            SearchEngine()
        }

        searchEngine.search()

        // as the result is set in a task detached from the call of search, I can't just test synchronously.
        // I could put the search method async, but it doesn't seems to be the good approach since I only need it for the test.
        for await currentResults in searchEngine.$results.values {
            guard !currentResults.isEmpty else {
                continue
            }

            XCTAssertFalse(searchEngine.results.isEmpty)
            let result = try XCTUnwrap(searchEngine.results.first)
            XCTAssertEqual(result.title, book.title)
            return
        }
    }

    func testAddAsAuthor() throws {
        let searchEngine = SearchEngine()

        let authorName = "AuthorName"

        searchEngine.currentSearch = authorName

        searchEngine.addAsAuthor()

        XCTAssertTrue(searchEngine.currentSearch.isEmpty)
        XCTAssertEqual(searchEngine.tokenBinding.wrappedValue.count, 1)
        let authorFromBinding = try XCTUnwrap(searchEngine.tokenBinding.wrappedValue.first)
        let author = try XCTUnwrap(searchEngine.author)
        XCTAssertEqual(author.author, authorName)
        XCTAssertEqual(authorFromBinding, author)
    }

    func testRemoveTokenFromBinding() throws {
        let searchEngine = SearchEngine()

        searchEngine.author = AuthorToken(author: "AuthorName")

        XCTAssertEqual(searchEngine.tokenBinding.wrappedValue.count, 1)

        searchEngine.tokenBinding.wrappedValue = []

        XCTAssertNil(searchEngine.author)
    }
}
