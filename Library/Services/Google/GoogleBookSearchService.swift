//
//  GoogleBookService.swift
//  Library
//
//  Created by Admin on 10/02/2023.
//

import Foundation

struct GoogleBookSearchService: BookSearchService {
    private static let googleAPI = "https://www.googleapis.com/books/v1/volumes"

    private let decoder = JSONDecoder()

    private func forgeURL(query: String, author: String?) throws -> URL {
        guard var components = URLComponents(string: Self.googleAPI) else {
            throw Error.unableToCreateURLComponent(Self.googleAPI)
        }
        let authorComponent = author.map { "+inauthor:\($0)" } ?? ""
        // Final query should be in the form of `q=TheBook+inauthor:TheAuthor`
        let query = query + authorComponent

        components.queryItems = [
            URLQueryItem(name: "q", value: query)
        ]

        guard let url = components.url else {
            throw Error.unableToCreateURL(components)
        }

        return url
    }

    // MARK: - BookSearchService

    func search(query: String, author: String?) async throws -> [any APIBook] {
        let url = try forgeURL(query: query, author: author)
        // TODO: check response for http code
        let (data, _) = try await URLSession.shared.data(from: url)

        let response = try decoder.decode(GoogleBookSearchResponse.self, from: data)

        return response.items
    }
}

// MARK: - Error
extension GoogleBookSearchService {
    enum Error: Swift.Error {
        case unableToCreateURLComponent(String)
        case unableToCreateURL(URLComponents)
    }
}
