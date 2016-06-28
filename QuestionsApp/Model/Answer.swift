//
//  Answer.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 6/7/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import Foundation

struct Answer {
	let id: Int64
	let questionID: Int64
	let text: String
	let isCorrect: Bool?
	let indexCorrect: Int?

	let isSelected: Bool
	let indexSelected: Int?

	init(id: Int64, questionID: Int64, text: String, isCorrect: Bool?, indexCorrect: Int?) {
		self.id = id
		self.questionID = questionID
		self.text = text
		self.isCorrect = isCorrect
		self.indexCorrect = indexCorrect

		self.isSelected = false
		self.indexSelected = nil
	}

	init(id: Int64, questionID: Int64, text: String, isCorrect: Bool?, indexCorrect: Int?, isSelected: Bool, indexSelected: Int?) {
		self.id = id
		self.questionID = questionID
		self.text = text
		self.isCorrect = isCorrect
		self.indexCorrect = indexCorrect

		self.isSelected = isSelected
		self.indexSelected = indexSelected
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
