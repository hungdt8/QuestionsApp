//
//  ExamEntity+CoreDataProperties.swift
//  
//
//  Created by Hung Le Duc on 11/12/16.
//
//

import Foundation
import CoreData

extension ExamEntity {

    @nonobjc public override class func fetchRequest() -> NSFetchRequest {
        return NSFetchRequest(entityName: "ExamEntity");
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int64
    @NSManaged public var categoryId: Int64
    @NSManaged public var isRandom: Bool
    @NSManaged public var questionList: NSOrderedSet?

}

// MARK: Generated accessors for questionList
extension ExamEntity {

    @objc(addQuestionListObject:)
    @NSManaged public func addToQuestionList(value: QuestionEntity)

    @objc(removeQuestionListObject:)
    @NSManaged public func removeFromQuestionList(value: QuestionEntity)

    @objc(addQuestionList:)
    @NSManaged public func addToQuestionList(values: NSSet)

    @objc(removeQuestionList:)
    @NSManaged public func removeFromQuestionList(values: NSSet)

}
