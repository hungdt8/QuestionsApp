//
//  Question.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 6/7/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import Foundation

enum QuestionType: Int {
	case OneChoose
	case MultiChoose
	case TextAnswer
	case Puzzle
	case Photo
}

enum Result: Int {
	case Right
	case Wrong
}

struct Question {
	let id: Int64
	let examID: Int64
	let type: QuestionType
	let question: String
	let photo: String?

	let answerList: [Answer]?

	func selectAnswer(answer: Answer) -> Question {
		let isSelectedAnswer = answer.isSelected
		guard !isSelectedAnswer else {
			return self
		}

		let selectedAnswer = answer.select()

		return replaceAnswer(answer, withAnswer: selectedAnswer)
	}

	func unSelectAnswer(answer: Answer) -> Question {
		let unSelectedAnswer = answer.unSelect()
		return replaceAnswer(answer, withAnswer: unSelectedAnswer)
	}

	func assignAnswer(answer: Answer, toIndex index: Int?) -> Question {
		let newAnswer = answer.assignToIndex(index)
		return replaceAnswer(answer, withAnswer: newAnswer)
	}

	func unassignAnswer(answer: Answer) -> Question {
		return assignAnswer(answer, toIndex: nil)
	}

	private func replaceAnswer(answer: Answer, withAnswer newAnswer: Answer) -> Question {
		var list = answerList
		if isSingleChoiceQuestion() { // single choice question
			for (index, ans) in list!.enumerate() {
				list![index] = (ans == answer) ? newAnswer : ans.unSelect()
			}
		} else { // multi choice question
			if let answerIndex = list?.indexOf({ $0.id == answer.id }) {
				list?[answerIndex] = newAnswer
			}
		}

		return Question(id: self.id, examID: self.examID, type: self.type, question: self.question, photo: self.photo, answerList: list)
	}

	private func isSingleChoiceQuestion() -> Bool {
		return (type == .OneChoose || type == .Photo) ? true : false
	}

	// MARK: -
	func checkResult() -> Result {
		switch type {
		case .OneChoose, .MultiChoose, .Photo:
			let rightAnswers = getRightAnswers()
			let selectedAnswers = getSelectedAnswers()
			return (rightAnswers == selectedAnswers) ? .Right : .Wrong
		case .TextAnswer:
			return .Right
		case .Puzzle:
			let rightAnswers = getOrderRightAnswer()
			let selectedAnswers = getOrderSelectedAnsers()
			guard rightAnswers.count == selectedAnswers.count else {
				return .Wrong
			}
			for (index, answer) in rightAnswers.enumerate() {
				let selectedAnswer = selectedAnswers[index]
				if answer != selectedAnswer {
					return .Wrong
				}
			}
			return.Right
		}
	}

	func getRightAnswers() -> [Answer] {
		return answerList!.filter { $0.isCorrect == true }
	}

	func getOrderRightAnswer() -> [Answer] {
		return answerList!.sort({ $0.indexCorrect < $1.indexCorrect })
	}

	func getRightTextAnswer() -> String {
		if answerList != nil {
			let rightAnswer = (type == .Puzzle) ? getOrderRightAnswer() : getRightAnswers()
			var string = String()
			for (index, answer) in rightAnswer.enumerate() {
				if index > 0 {
					string = string.stringByAppendingString(", ")
				}
				string = string.stringByAppendingString(answer.text)
			}
			return string
		} else {
			return ""
		}
	}

	func getSelectedAnswers() -> [Answer] {
		return answerList!.filter { $0.isSelected == true }
	}

	func getOrderSelectedAnsers() -> [Answer] {
		let array = answerList!.filter { $0.indexSelected != nil }
		return array.sort({ $0.indexSelected < $1.indexSelected })
	}

	func isUserChooseAnswer() -> Bool {
		switch type {
		case .OneChoose, .MultiChoose, .Photo:
			return (getSelectedAnswers().count > 0) ? true : false
		case .TextAnswer:
			return true
		case .Puzzle:
			return (getOrderSelectedAnsers().count > 0) ? true : false
		}

	}
}

// MARK: Equatable
func == (left: Question, right: Question) -> Bool {
	return (left.id == right.id)
}
