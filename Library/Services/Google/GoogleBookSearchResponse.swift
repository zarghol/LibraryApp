//
//  GoogleBookSearchResponse.swift
//  Library
//
//  Created by Admin on 10/02/2023.
//

import Foundation

struct GoogleBookSearchResponse: Decodable {
    let kind: String
    let totalItems: Int
    let items: [GoogleAPIBook]

    enum CodingKeys: CodingKey {
        case kind
        case totalItems
        case items
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.kind = try container.decode(String.self, forKey: .kind)
        self.totalItems = try container.decode(Int.self, forKey: .totalItems)
        self.items = try container.decodeIfPresent([GoogleAPIBook].self, forKey: .items) ?? []
    }
}
