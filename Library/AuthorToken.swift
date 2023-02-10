//
//  AuthorToken.swift
//  Library
//
//  Created by Admin on 10/02/2023.
//

import Foundation

/// A search token in order to search filtering with this author
struct AuthorToken: Identifiable, Hashable {
    var id: String { author }

    let author: String
}
