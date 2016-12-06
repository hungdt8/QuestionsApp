//
//  QuestionEntity+CoreDataProperties.swift
//  
//
//  Created by Hung Le Duc on 11/12/16.
//
//

import Foundation
import CoreData

extension QuestionEntity {

    @nonobjc public override class func fetchRequest() -> NSFetchRequest {
        return NSFetchRequest(entityName: "QuestionEntity");
    }

    @NSManaged public var id: Int64
    @NSManaged public var type: Int16
    @NSManaged public var question: String?
    @NSManaged public var photo: String?
    @NSManaged public var order: Int16
    @NSManaged public var answerText: String?
    @NSManaged public var answerList: NSOrderedSet?

}

// MARK: Generated accessors for answerList
extension QuestionEntity {

    @objc(addAnswerListObject:)
    @NSManaged public func addToAnswerList(value: AnswerEntity)

    @objc(removeAnswerListObject:)
    @NSManaged public func removeFromAnswerList(value: AnswerEntity)

    @objc(addAnswerList:)
    @NSManaged public func addToAnswerList(values: NSSet)

    @objc(removeAnswerList:)
    @NSManaged public func removeFromAnswerList(values: NSSet)

}
