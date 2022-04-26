//
//  Subject+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 26/04/22.
//
//

import Foundation
import CoreData


extension Subject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subject> {
        return NSFetchRequest<Subject>(entityName: "Subject")
    }

    @NSManaged public var name: String?
    @NSManaged public var latestDate: Date?
    @NSManaged public var greenProgress: Double
    @NSManaged public var yellowProgress: Double
    @NSManaged public var redProgress: Double
    @NSManaged public var topic: [Topic]?

}

// MARK: Generated accessors for topic
extension Subject {

    @objc(insertObject:inTopicAtIndex:)
    @NSManaged public func insertIntoTopic(_ value: Topic, at idx: Int)

    @objc(removeObjectFromTopicAtIndex:)
    @NSManaged public func removeFromTopic(at idx: Int)

    @objc(insertTopic:atIndexes:)
    @NSManaged public func insertIntoTopic(_ values: [Topic], at indexes: NSIndexSet)

    @objc(removeTopicAtIndexes:)
    @NSManaged public func removeFromTopic(at indexes: NSIndexSet)

    @objc(replaceObjectInTopicAtIndex:withObject:)
    @NSManaged public func replaceTopic(at idx: Int, with value: Topic)

    @objc(replaceTopicAtIndexes:withTopic:)
    @NSManaged public func replaceTopic(at indexes: NSIndexSet, with values: [Topic])

    @objc(addTopicObject:)
    @NSManaged public func addToTopic(_ value: Topic)

    @objc(removeTopicObject:)
    @NSManaged public func removeFromTopic(_ value: Topic)

    @objc(addTopic:)
    @NSManaged public func addToTopic(_ values: NSOrderedSet)

    @objc(removeTopic:)
    @NSManaged public func removeFromTopic(_ values: NSOrderedSet)

}

extension Subject : Identifiable {

}
