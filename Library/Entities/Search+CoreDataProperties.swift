//
//  Search+CoreDataProperties.swift
//  Library
//
//  Created by Admin on 11/02/2023.
//

import Foundation
import CoreData

extension Search {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Search> {
        return NSFetchRequest<Search>(entityName: "Search")
    }

    @NSManaged public var author: String?
    @NSManaged public var query: String
    @NSManaged public var timestamp: Date
}

extension Search: Identifiable {}
