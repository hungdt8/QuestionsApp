//
//  Exam.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 6/7/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import Foundation

struct Exam {
	let id: Int64
	let name: String
	let categoryID: Int
	let questionList: [Question]

	func selectAnswer(answer: Answer, ofQuestion question: Question) -> Exam {
		let newQuestion = question.selectAnswer(answer)
		return replaceQuesion(question, withQuestion: newQuestion)
	}

	func unSelectAnswer(answer: Answer, ofQuestion question: Question) -> Exam {
		let newQuestion = question.unSelectAnswer(answer)
		return replaceQuesion(question, withQuestion: newQuestion)
	}

	func assignAnswer(answer: Answer, ofQuestion question: Question, atIndex index: Int?) -> Exam {
		let newQuestion = question.assignAnswer(answer, toIndex: index)
		return replaceQuesion(question, withQuestion: newQuestion)
	}

	func unassignAnswer(answer: Answer, ofQuestion question: Question) -> Exam {
		return assignAnswer(answer, ofQuestion: question, atIndex: nil)
	}

	private func replaceQuesion(question: Question, withQuestion newQuestion: Question) -> Exam {
		var list = questionList
		if let questionIndex = list.indexOf({ $0.id == question.id }) {
			list[questionIndex] = newQuestion
		}
		return Exam(id: self.id, name: self.name, categoryID: self.categoryID, questionList: list)
	}
}
