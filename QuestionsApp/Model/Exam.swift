//
//  Exam.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 6/7/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import Foundation
import ObjectMapper

struct Exam: Mappable {
	var id: Int = 0
	var name: String = ""
	var categoryID: Int = 0
	var questionList: [Question] = [Question]()
    var isRandom: Bool = false

    init(id: Int, name: String, categoryID: Int, questionList: [Question], isRandom: Bool) {
        self.id = id
        self.name = name
        self.categoryID = categoryID
        self.questionList = questionList
        self.isRandom = isRandom
    }
    
    init?(_ map: Map) {
        
    }
    
    init(examEntity: ExamEntity) {
        self.id = Int(examEntity.id)
        self.name = examEntity.name ?? ""
        self.categoryID = Int(examEntity.categoryId)
        self.questionList = [Question]()
        if let list = examEntity.questionList {
            for questionEntity in list { 
                let question = Question(questionEntity: questionEntity as! QuestionEntity)
                self.questionList.append(question)
            }
        }
        self.isRandom = examEntity.isRandom
    }
    
    mutating func mapping(map: Map) {
        id     <- map["IdExam"]
        name  <- map["NameExam"]
        categoryID <- map["IdCate"]
    }
    
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

    func updateAnswerText(string: String, ofQuestion question: Question) -> Exam {
        let newQuestion = question.updateAnswerText(string)
        return replaceQuesion(question, withQuestion: newQuestion)
    }
    
	private func replaceQuesion(question: Question, withQuestion newQuestion: Question) -> Exam {
		var list = questionList
		if let questionIndex = list.indexOf({ $0.id == question.id }) {
			list[questionIndex] = newQuestion
		}
		return Exam(id: self.id, name: self.name, categoryID: self.categoryID, questionList: list, isRandom: self.isRandom)
	}
    
    // MARK: - Progress
    func getProgress() -> Float {
        guard questionList.count > 0 else {
            return 0
        }
        
        var numberChoosedAnswer = 0
        for (_,question) in questionList.enumerate() {
            if question.isUserChooseAnswer() == true {
                numberChoosedAnswer += 1
            }
        }
        return Float(numberChoosedAnswer)/Float(questionList.count)
    }
    
    func getProgressString() -> String {
        guard questionList.count > 0 else {
            return "0/0"
        }
        
        var numberChoosedAnswer = 0
        for (_,question) in questionList.enumerate() {
            if question.isUserChooseAnswer() == true {
                numberChoosedAnswer += 1
            }
        }
        return String(format: "%d/%d", numberChoosedAnswer,questionList.count)
    }
}
