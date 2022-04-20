//
//  Topicos+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 20/04/22.
//
//

import Foundation
import CoreData


extension Topicos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Topicos> {
        return NSFetchRequest<Topicos>(entityName: "Topicos")
    }

    @NSManaged public var nome: String?
    @NSManaged public var assunto: Assunto?
    @NSManaged public var data: NSSet?

}

// MARK: Generated accessors for data
extension Topicos {

    @objc(addDataObject:)
    @NSManaged public func addToData(_ value: DataEstudo)

    @objc(removeDataObject:)
    @NSManaged public func removeFromData(_ value: DataEstudo)

    @objc(addData:)
    @NSManaged public func addToData(_ values: NSSet)

    @objc(removeData:)
    @NSManaged public func removeFromData(_ values: NSSet)

}

extension Topicos : Identifiable {

}
