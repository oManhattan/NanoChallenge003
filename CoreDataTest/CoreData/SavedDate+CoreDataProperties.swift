//
//  SavedDate+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 25/04/22.
//
//

import Foundation
import CoreData


extension SavedDate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedDate> {
        return NSFetchRequest<SavedDate>(entityName: "SavedDate")
    }

    @NSManaged public var date: Date?
    @NSManaged public var status: Int64
    @NSManaged public var notes: String?
    @NSManaged public var topic: Topic?

}

extension SavedDate : Identifiable {

}
