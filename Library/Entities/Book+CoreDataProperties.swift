//
//  Book+CoreDataProperties.swift
//  Library
//
//  Created by Admin on 11/02/2023.
//

import Foundation
import CoreData

extension Book {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var author: String?
    @NSManaged public var desc: String
    @NSManaged public var identifier: String
    @NSManaged public var picture: Data?
    @NSManaged public var title: String

}

extension Book: Identifiable {

}
