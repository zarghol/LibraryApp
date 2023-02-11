//
//  AnyAPIBook.swift
//  Library
//
//  Created by Admin on 11/02/2023.
//

import Foundation

/// Type eraser for the book allowing to use it where Hashable is needed (typically as a value for navigation destination).
struct AnyAPIBook: APIBook, Sendable, Hashable {
    let wrapped: any APIBook

    var id: String { wrapped.id }
    var url: URL { wrapped.url }
    var title: String { wrapped.title }
    var authors: [String] { wrapped.authors }
    var description: String? { wrapped.description }
    var imageURL: URL? { wrapped.imageURL }

    static func == (lhs: AnyAPIBook, rhs: AnyAPIBook) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
