//
//  CoreDataSuggestionsServiceTests.swift
//  LibraryTests
//
//  Created by Admin on 11/02/2023.
//

import XCTest
import Dependencies
import CoreData

@testable import Library

final class CoreDataSuggestionsServiceTests: XCTestCase {

    let service = CoreDataSuggestionsService()
    override func setUpWithError() throws {
        try super.setUpWithError()

        // Delete all objects in context, as the dependency is persisted between tests
        let deleteRequest = NSBatchDeleteRequest.init(fetchRequest: Search.fetchRequest())
        try service.context.persistentStoreCoordinator?.execute(deleteRequest, with: service.context)
    }

    func testWithoutAuthors() throws {
        let query = "TestQuery"
        try service.createSuggestion(query: query, author: nil)

        let fetchedSuggestions = try service.context.fetch(Search.fetchRequest())

        XCTAssertEqual(fetchedSuggestions.count, 1)
        let fetchedSuggestion = try XCTUnwrap(fetchedSuggestions.first)

        XCTAssertNil(fetchedSuggestion.author)
        XCTAssertEqual(fetchedSuggestion.query, query)
    }

    func testWithAuthors() throws {
        let query = "TestQuery2"
        let author = "Author"
        try service.createSuggestion(query: query, author: author)

        let fetchedSuggestions = try service.context.fetch(Search.fetchRequest())

        XCTAssertEqual(fetchedSuggestions.count, 1)
        let fetchedSuggestion = try XCTUnwrap(fetchedSuggestions.first)

        XCTAssertEqual(fetchedSuggestion.author, author)
        XCTAssertEqual(fetchedSuggestion.query, query)
    }
}
