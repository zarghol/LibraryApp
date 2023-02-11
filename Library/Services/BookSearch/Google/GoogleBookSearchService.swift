//
//  GoogleBookService.swift
//  Library
//
//  Created by Admin on 10/02/2023.
//

import Foundation

/// Search API, calling Google api.
struct GoogleBookSearchService: BookSearchService {
    private static let googleAPI = "https://www.googleapis.com/books/v1/volumes"

    private let decoder = JSONDecoder()

    /// Create the url to call with a particular query and author value.
    /// - Parameters:
    ///   - query: The general text to search.
    ///   - author: The content of the author part of the query.
    /// - Returns: A well formed url pointing the the json response we want for this query.
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
        let (data, urlResponse) = try await URLSession.shared.data(from: url)

        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            throw Error.invalidResponse(urlResponse)
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw Error.invalidResponse(urlResponse)
        }

        let response = try decoder.decode(GoogleBookSearchResponse.self, from: data)

        // remove duplicates
        let set = Set(response.items)

        return Array(set)
    }
}

// MARK: - Error
extension GoogleBookSearchService {
    enum Error: Swift.Error {
        case unableToCreateURLComponent(String)
        case unableToCreateURL(URLComponents)
        case invalidResponse(URLResponse)
    }
}
