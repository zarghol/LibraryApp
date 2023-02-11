//
//  SuggestionsService.swift
//  Library
//
//  Created by Admin on 10/02/2023.
//

import Foundation
import Dependencies

protocol SuggestionsService: Sendable {
    func createSuggestion(query: String, author: String?) throws
}

// MARK: - Dependency Definition

struct MockSuggestionsService: SuggestionsService {
    func createSuggestion(query: String, author: String?) throws {
        // Nothing to do
    }
}

private enum SuggestionsServiceKey: DependencyKey {
    static let liveValue: any SuggestionsService = CoreDataSuggestionsService()
    static let previewValue: any SuggestionsService = MockSuggestionsService()
    static let testValue: any SuggestionsService = MockSuggestionsService()
}

extension DependencyValues {
    var suggestionsService: SuggestionsService {
        get { self[SuggestionsServiceKey.self] }
        set { self[SuggestionsServiceKey.self] = newValue }
    }
}
