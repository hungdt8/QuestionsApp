//
//  Answer.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 6/7/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import Foundation
import ObjectMapper

struct Answer: Mappable {
	var id: Int = 0
	var questionID: Int = 0
	var text: String = ""
	var isCorrect: Bool?
	var indexCorrect: Int?

	var isSelected: Bool = false
	var indexSelected: Int?

	init(id: Int, questionID: Int, text: String, isCorrect: Bool?, indexCorrect: Int?, isSelected: Bool = false, indexSelected: Int? = nil) {
		self.id = id
		self.questionID = questionID
		self.text = text
		self.isCorrect = isCorrect
		self.indexCorrect = indexCorrect

		self.isSelected = isSelected
		self.indexSelected = indexSelected
	}

    init?(_ map: Map) {
        
    }
    
    init(answerEntity: AnswerEntity) {
        self.id = Int(answerEntity.id)
//        self.questionID = Int(anwserEntity.que)
        self.text = answerEntity.text ?? ""
        self.isCorrect = answerEntity.isCorrect
        self.indexCorrect = Int(answerEntity.indexCorrect)
        self.isSelected = answerEntity.isSelected
        self.indexSelected = Int(answerEntity.indexSelected)
    }
    
    mutating func mapping(map: Map) {
        id     <- map["IdChoice"]
        questionID  <- map["IdQuest"]
        text <- map["ContentChoice"]
        indexCorrect <- map["IsCorect"]
        isCorrect <- map["IsCorect"]
    }
    
	func isEqualTo(other: Answer) -> Bool {
		return self.id == other.id
	}

	func select() -> Answer {
		return Answer(id: id, questionID: questionID, text: text, isCorrect: isCorrect, indexCorrect: indexCorrect, isSelected: true, indexSelected: nil)
	}

	func unSelect() -> Answer {
		return Answer(id: id, questionID: questionID, text: text, isCorrect: isCorrect, indexCorrect: indexCorrect, isSelected: false, indexSelected: nil)
	}

	func assignToIndex(index: Int?) -> Answer {
		return Answer(id: id, questionID: questionID, text: text, isCorrect: isCorrect, indexCorrect: indexCorrect, isSelected: false, indexSelected: index)
	}

	func unassign() -> Answer {
		return assignToIndex(nil)
	}
}

// MARK: Equatable
func == (left: Answer, right: Answer) -> Bool {
	return (left.id == right.id)
}

func != (left: Answer, right: Answer) -> Bool {
	return (left.id != right.id)
}

func == (lhs: [Answer], rhs: [Answer]) -> Bool {
	guard lhs.count == rhs.count else { return false }
	var i1 = lhs.generate()
	var i2 = rhs.generate()
	var isEqual = true
	while let e1 = i1.next(), e2 = i2.next() where isEqual {
		isEqual = e1 == e2
	}
	return isEqual
}
