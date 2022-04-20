//
//  DataEstudo+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 20/04/22.
//
//

import Foundation
import CoreData


extension DataEstudo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataEstudo> {
        return NSFetchRequest<DataEstudo>(entityName: "DataEstudo")
    }

    @NSManaged public var data: Date?
    @NSManaged public var notas: String?
    @NSManaged public var status: String?
    @NSManaged public var topico: Topicos?

}

extension DataEstudo : Identifiable {

}
