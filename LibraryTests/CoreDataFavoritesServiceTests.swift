//
//  CoreDataFavoritesServiceTests.swift
//  LibraryTests
//
//  Created by Admin on 11/02/2023.
//

import XCTest
import Dependencies
import CoreData

@testable import Library

final class CoreDataFavoritesServiceTests: XCTestCase {

    let service = CoreDataFavoritesService()
    override func setUpWithError() throws {
        try super.setUpWithError()

        // Delete all objects in context, as the dependency is persisted between tests
        let deleteRequest = NSBatchDeleteRequest.init(fetchRequest: Book.fetchRequest())
        try service.context.persistentStoreCoordinator?.execute(deleteRequest, with: service.context)
    }

    func testCreateWithoutImage() throws {
        let book = MockAPIBook(
            id: "id",
            url: URL(string: "https://")!,
            title: "test book",
            authors: ["author 1"],
            description: "description",
            imageURL: URL(string: "https://books.google.com/books/publisher/content?id=dRKHAQAAQBAJ&printsec=frontcover&img=1&zoom=1")!
        )
        try service.createFavorite(book: book, pictureData: nil)

        let fetchedBooks = try service.context.fetch(Book.fetchRequest())

        XCTAssertEqual(fetchedBooks.count, 1)
        let fetchedBook = try XCTUnwrap(fetchedBooks.first)

        XCTAssertEqual(fetchedBook.identifier, book.id)
        XCTAssertEqual(fetchedBook.title, book.title)
        XCTAssertEqual(fetchedBook.author, book.authors.first)
        XCTAssertEqual(fetchedBook.desc, book.description)
        XCTAssertNil(fetchedBook.picture)
    }

    func testCreateWithImage() throws {
        let bundle = Bundle(for: Self.self)
        let imageUrl = bundle.url(forResource: "imageTest", withExtension: "jpeg")!
        let imageData = try Data(contentsOf: imageUrl)

        let book = MockAPIBook(
            id: "id",
            url: URL(string: "https://")!,
            title: "test book",
            authors: ["author 1"],
            description: "description",
            imageURL: URL(string: "https://books.google.com/books/publisher/content?id=dRKHAQAAQBAJ&printsec=frontcover&img=1&zoom=1")!
        )
        try service.createFavorite(book: book, pictureData: imageData)

        let fetchedBooks = try service.context.fetch(Book.fetchRequest())

        XCTAssertEqual(fetchedBooks.count, 1)
        let fetchedBook = try XCTUnwrap(fetchedBooks.first)

        XCTAssertEqual(fetchedBook.identifier, book.id)
        XCTAssertEqual(fetchedBook.title, book.title)
        XCTAssertEqual(fetchedBook.author, book.authors.first)
        XCTAssertEqual(fetchedBook.desc, book.description)
        XCTAssertEqual(fetchedBook.picture, imageData)
    }

    func testRemove() throws {
        let identifier = "id"
        let newBook = Book(context: service.context)
        newBook.identifier = identifier
        newBook.author = "author"
        newBook.title = "title"
        newBook.desc = "description"

        try service.context.save()

        try service.removeFavorite(bookIdentifier: identifier)

        let fetchedSuggestions = try service.context.fetch(Search.fetchRequest())

        XCTAssertTrue(fetchedSuggestions.isEmpty)
    }

    func testGet() throws {
        let identifier = "id"
        let newBook = Book(context: service.context)
        newBook.identifier = identifier
        newBook.author = "author"
        newBook.title = "title"
        newBook.desc = "description"

        try service.context.save()

        let fetchedBook = service.getFavorite(bookIdentifier: identifier)

        XCTAssertEqual(fetchedBook?.identifier, newBook.identifier)
        XCTAssertEqual(fetchedBook?.title, newBook.title)
        XCTAssertEqual(fetchedBook?.author, newBook.author)
        XCTAssertEqual(fetchedBook?.desc, newBook.desc)
        XCTAssertEqual(fetchedBook?.picture, newBook.picture)
    }
}
