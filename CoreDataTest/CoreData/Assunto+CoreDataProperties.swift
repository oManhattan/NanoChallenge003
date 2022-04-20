//
//  Assunto+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 20/04/22.
//
//

import Foundation
import CoreData


extension Assunto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Assunto> {
        return NSFetchRequest<Assunto>(entityName: "Assunto")
    }

    @NSManaged public var nome: String?
    @NSManaged public var topico: NSSet?

}

// MARK: Generated accessors for topico
extension Assunto {

    @objc(addTopicoObject:)
    @NSManaged public func addToTopico(_ value: Topicos)

    @objc(removeTopicoObject:)
    @NSManaged public func removeFromTopico(_ value: Topicos)

    @objc(addTopico:)
    @NSManaged public func addToTopico(_ values: NSSet)

    @objc(removeTopico:)
    @NSManaged public func removeFromTopico(_ values: NSSet)

}

extension Assunto : Identifiable {

}
