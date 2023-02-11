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
