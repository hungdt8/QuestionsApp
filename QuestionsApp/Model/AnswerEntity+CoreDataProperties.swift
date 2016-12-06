//
//  AnswerEntity+CoreDataProperties.swift
//  
//
//  Created by Hung Le Duc on 11/12/16.
//
//

import Foundation
import CoreData


extension AnswerEntity {

    @nonobjc public override class func fetchRequest() -> NSFetchRequest {
        return NSFetchRequest(entityName: "AnswerEntity");
    }

    @NSManaged public var id: Int64
    @NSManaged public var text: String?
    @NSManaged public var isCorrect: Bool
    @NSManaged public var indexCorrect: Int16
    @NSManaged public var isSelected: Bool
    @NSManaged public var indexSelected: Int16

}
