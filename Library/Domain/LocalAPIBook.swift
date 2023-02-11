//
//  LocalAPIBook.swift
//  Library
//
//  Created by Admin on 11/02/2023.
//

import Foundation

struct LocalAPIBook: APIBook, Sendable {
    let id: String
    var url: URL { URL(string: "https://")! }
    let title: String
    let authors: [String]
    let description: String?
    let imageURL: URL?
}
