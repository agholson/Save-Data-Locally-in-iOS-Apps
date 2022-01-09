//
//  Person+CoreDataProperties.swift
//  Core Data Demo (iOS)
//
//  Created by Leone on 1/9/22.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var gender: String?
    @NSManaged public var age: Int64
    @NSManaged public var array: [String]?

}

extension Person : Identifiable {

}
