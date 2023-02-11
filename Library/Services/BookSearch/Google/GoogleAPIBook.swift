//
//  GoogleAPIBook.swift
//  Library
//
//  Created by Admin on 10/02/2023.
//

import Foundation

struct GoogleAPIBook: APIBook {
    let id: String
    let url: URL
    let title: String
    let authors: [String]
    let description: String?

    var imageURL: URL? {
        URL(string: "http://books.google.com/books/publisher/content?id=\(id)&printsec=frontcover&img=1&zoom=1")
    }
}

extension GoogleAPIBook: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case url = "selfLink"
        case volumeInfo
    }

    enum VolumeInfoCodingKeys: String, CodingKey {
        case title
        case subtitle
        case authors
        case description
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.url = try container.decode(URL.self, forKey: .url)

        if container.contains(.volumeInfo) {
            let innerContainer = try container.nestedContainer(keyedBy: VolumeInfoCodingKeys.self, forKey: .volumeInfo)

            self.title = try innerContainer.decode(String.self, forKey: .title)
            self.description = try innerContainer.decodeIfPresent(String.self, forKey: .description)
            self.authors = try innerContainer.decodeIfPresent([String].self, forKey: .authors) ?? []
        } else {
            self.title = ""
            self.description = ""
            self.authors = []
        }
    }
}

extension GoogleAPIBook: Hashable {
    static func == (lhs: GoogleAPIBook, rhs: GoogleAPIBook) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
