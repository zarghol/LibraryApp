//
//  MockAPIBook.swift
//  LibraryTests
//
//  Created by Admin on 10/02/2023.
//

import Foundation

@testable import Library

struct MockAPIBook: APIBook, Equatable {
    var id: String
    var url: URL
    var title: String
    var authors: [String]
    var description: String?
    var imageURL: URL

    init(id: String = UUID().uuidString, url: URL = URL(string: "https://")!, title: String = "", authors: [String] = [], description: String? = nil, imageURL: URL = URL(string: "https://")!) {
        self.id = id
        self.url = url
        self.title = title
        self.authors = authors
        self.description = description
        self.imageURL = imageURL
    }
}
