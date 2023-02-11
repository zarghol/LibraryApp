//
//  APIBook.swift
//  Library
//
//  Created by Admin on 10/02/2023.
//

import Foundation

protocol APIBook: Sendable {
    var id: String { get }
    var url: URL { get }
    var title: String { get }
    var authors: [String] { get }
    var description: String? { get }
    var imageURL: URL { get }
}

struct AnyAPIBook: APIBook, Sendable, Hashable {
    let wrapped: any APIBook

    var id: String { wrapped.id }
    var url: URL { wrapped.url }
    var title: String { wrapped.title }
    var authors: [String] { wrapped.authors }
    var description: String? { wrapped.description }
    var imageURL: URL { wrapped.imageURL }

    static func == (lhs: AnyAPIBook, rhs: AnyAPIBook) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
