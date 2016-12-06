//
//  Question.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 6/7/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import Foundation
import ObjectMapper

enum QuestionType: Int {
	case OneChoose = 1
	case MultiChoose = 2
	case TextAnswer = 3
	case Puzzle = 4
	case Photo = 5
}

enum Result: Int {
	case Right
	case Wrong
}

struct Question: Mappable {
	var id: Int = 0
	var examID: Int = 0
	var type: QuestionType = .OneChoose
	var question: String = ""
	var photo: String?
	var order: Int?

	var answerList: [Answer]?
    
    var answerText: String?

    init(id: Int, examID: Int, type: QuestionType, question: String, photo: String?, order: Int?, answerList: [Answer]?, answerText: String? = nil) {
        self.id = id
        self.question = question
        self.examID = examID
        self.type = type
        self.photo = photo
        self.order = order
        self.answerList = answerList
        self.answerText = answerText
    }
    
    init?(_ map: Map) {
        
    }
    
    init(questionEntity: QuestionEntity) {
        self.id = Int(questionEntity.id)
        self.question = questionEntity.question ?? ""
        self.type = QuestionType(rawValue: Int(questionEntity.type))!
        self.photo = questionEntity.photo
        self.order = Int(questionEntity.order)
        self.answerText = questionEntity.answerText
        
        if let answerList = questionEntity.answerList {
            self.answerList = [Answer]()
            for answerEntity in answerList {
                let answer = Answer(answerEntity: answerEntity as! AnswerEntity)
                self.answerList?.append(answer)
            }
        }
    }
    
    mutating func mapping(map: Map) {
        id     <- map["id"]
//        examID  <- map[""]
        type <- map["loai"]
        question <- map["contentQuestion"]
        photo <- map["image"]
//        order <- map["IdCate"]
        answerList <- map["Choice"]
    }
    
    
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

    func updateAnswerText(string: String) -> Question {
        return Question(id: self.id, examID: self.examID, type: self.type, question: self.question, photo: self.photo, order: self.order, answerList: self.answerList, answerText: string)
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

		return Question(id: self.id, examID: self.examID, type: self.type, question: self.question, photo: self.photo, order: self.order, answerList: list)
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
            guard let rightAnswer = getRightAnswers().first else { // server ko tra ve cau tra loi dung --> mac nhien dung
                return .Right
            }
            guard let answerText = answerText else {
                return .Wrong
            }
            
            let rightText = rightAnswer.text.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByReplacingOccurrencesOfString(" ", withString: "")
            let text = answerText.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByReplacingOccurrencesOfString(" ", withString: "")
            
            if text == rightText {
                return .Right
            } else {
                return .Wrong
            }
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
        guard !isEmptyAnswerList() else {
            return true
        }
        
		switch type {
		case .OneChoose, .MultiChoose, .Photo:
			return (getSelectedAnswers().count > 0) ? true : false
		case .TextAnswer:
			return true
		case .Puzzle:
			return (getOrderSelectedAnsers().count > 0) ? true : false
		}

	}
    
    func isEmptyAnswerList() -> Bool {
        guard let isEmpty = answerList?.isEmpty else {
            return true
        }
        return isEmpty
    }
}

// MARK: Equatable
func == (left: Question, right: Question) -> Bool {
	return (left.id == right.id)
}
