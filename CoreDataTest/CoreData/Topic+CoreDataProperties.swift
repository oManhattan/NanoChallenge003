//
//  Topic+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 25/04/22.
//
//

import Foundation
import CoreData


extension Topic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Topic> {
        return NSFetchRequest<Topic>(entityName: "Topic")
    }

    @NSManaged public var name: String?
    @NSManaged public var lastSavedDate: Date?
    @NSManaged public var lastSavedStatus: Int64
    @NSManaged public var subject: Subject?
    @NSManaged public var savedDate: NSOrderedSet?

}

// MARK: Generated accessors for savedDate
extension Topic {

    @objc(insertObject:inSavedDateAtIndex:)
    @NSManaged public func insertIntoSavedDate(_ value: SavedDate, at idx: Int)

    @objc(removeObjectFromSavedDateAtIndex:)
    @NSManaged public func removeFromSavedDate(at idx: Int)

    @objc(insertSavedDate:atIndexes:)
    @NSManaged public func insertIntoSavedDate(_ values: [SavedDate], at indexes: NSIndexSet)

    @objc(removeSavedDateAtIndexes:)
    @NSManaged public func removeFromSavedDate(at indexes: NSIndexSet)

    @objc(replaceObjectInSavedDateAtIndex:withObject:)
    @NSManaged public func replaceSavedDate(at idx: Int, with value: SavedDate)

    @objc(replaceSavedDateAtIndexes:withSavedDate:)
    @NSManaged public func replaceSavedDate(at indexes: NSIndexSet, with values: [SavedDate])

    @objc(addSavedDateObject:)
    @NSManaged public func addToSavedDate(_ value: SavedDate)

    @objc(removeSavedDateObject:)
    @NSManaged public func removeFromSavedDate(_ value: SavedDate)

    @objc(addSavedDate:)
    @NSManaged public func addToSavedDate(_ values: NSOrderedSet)

    @objc(removeSavedDate:)
    @NSManaged public func removeFromSavedDate(_ values: NSOrderedSet)

}

extension Topic : Identifiable {

}
