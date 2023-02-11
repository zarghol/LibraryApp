//
//  APIBook.swift
//  Library
//
//  Created by Admin on 10/02/2023.
//

import Foundation

protocol APIBook: Sendable, Hashable {
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

struct LocalAPIBook: APIBook, Sendable {
    let id: String
    var url: URL { URL(string: "https://")! }
    let title: String
    let authors: [String]
    let description: String?
    let imageURL: URL
}

extension LocalAPIBook {
    init(book: Book) {
        self.id = book.identifier!
        self.title = book.title ?? ""
        self.authors = [book.author].compactMap { $0 }
        self.description = book.description
        if let data = book.picture {
            let url = FileManager.default.temporaryDirectory.appending(path: book.identifier!)
            try? data.write(to: url)
            self.imageURL = url
        } else {
            self.imageURL = URL(string: "https://")!
        }
    }
}
