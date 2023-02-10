//
//  XCTTry.swift
//  LibraryTests
//
//  Created by Admin on 10/02/2023.
//

import Foundation

struct XCTestReadableError: LocalizedError {
    let innerError: any Error

    var errorDescription: String? {
        "\(innerError)"
    }
}

/// Helper method throwing a readable error from Unit Tests.
///
///  The throwing Unit Tests display errors thanks to localizedDescription which is not helpful in some cases like
///  ```
///  testSearchNoAuthor(): failed: caught error: "The operation couldn’t be completed. (Library.GoogleBookSearchService.Error error 0.)"
///  ```
///  This wrapper allows to have the real description of the swift error.
/// - Parameter block: Throwing block to execute
/// - Throws: A readable error wrapping the error thrown by the `block`.
func XCTTry(_ block: () throws -> Void) rethrows {
    do {
        try block()
    } catch {
        throw XCTestReadableError(innerError: error)
    }
}

/// Helper method throwing a readable error from Unit Tests.
///
///  The throwing Unit Tests display errors thanks to localizedDescription which is not helpful in some cases like
///  ```
///  testSearchNoAuthor(): failed: caught error: "The operation couldn’t be completed. (Library.GoogleBookSearchService.Error error 0.)"
///  ```
///  This wrapper allows to have the real description of the swift error.
/// - Parameter block: Throwing block to execute
/// - Throws: A readable error wrapping the error thrown by the `block`.
func XCTTry(_ block: () async throws -> Void) async rethrows {
    do {
        try await block()
    } catch {
        throw XCTestReadableError(innerError: error)
    }
}
