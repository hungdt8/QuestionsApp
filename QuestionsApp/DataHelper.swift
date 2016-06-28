//
//  DataHelper.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 6/18/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import Foundation

class DataHelper {
	var examHomeList: [Exam]!
	var exam: Exam!

	init() {
		generateDummyContent()
	}

	func generateDummyContent() {
		let answer1_1 = Answer(id: 1, questionID: 1, text: "A", isCorrect: true, indexCorrect: nil)
		let answer2_1 = Answer(id: 2, questionID: 1, text: "B", isCorrect: false, indexCorrect: nil)
		let answer3_1 = Answer(id: 3, questionID: 1, text: "C", isCorrect: false, indexCorrect: nil)
		let answer4_1 = Answer(id: 4, questionID: 1, text: "D", isCorrect: false, indexCorrect: nil)
		let question1 = Question(id: 1, examID: 1, type: .OneChoose, question: "abcd sdweoi  fosie  sodifeo sdfjoiwef sdfjoeiw soidfjwoeifsdf oiowf?", photo: nil, answerList: [answer1_1, answer2_1, answer3_1, answer4_1])

		let answer1_2 = Answer(id: 5, questionID: 2, text: "E", isCorrect: true, indexCorrect: nil)
		let answer2_2 = Answer(id: 6, questionID: 2, text: "F", isCorrect: true, indexCorrect: nil)
		let answer3_2 = Answer(id: 7, questionID: 2, text: "G", isCorrect: false, indexCorrect: nil)
		let answer4_2 = Answer(id: 8, questionID: 2, text: "H", isCorrect: false, indexCorrect: nil)
		let question2 = Question(id: 2, examID: 1, type: .MultiChoose, question: "efgh sdweoi  fosie  sodifeo sdfjoiwef sdfjoeiw soidfjwoeifsdf oiowf?", photo: nil, answerList: [answer1_2, answer2_2, answer3_2, answer4_2])

		let answer1_3 = Answer(id: 9, questionID: 3, text: "I", isCorrect: true, indexCorrect: nil)
		let answer2_3 = Answer(id: 10, questionID: 3, text: "J", isCorrect: false, indexCorrect: nil)
		let answer3_3 = Answer(id: 11, questionID: 3, text: "K", isCorrect: false, indexCorrect: nil)
		let answer4_3 = Answer(id: 12, questionID: 3, text: "L", isCorrect: false, indexCorrect: nil)
		let question3 = Question(id: 3, examID: 1, type: .Photo, question: "ijkl sdweoi?", photo: "a.png", answerList: [answer1_3, answer2_3, answer3_3, answer4_3])

		let answer1_4 = Answer(id: 13, questionID: 4, text: "M", isCorrect: nil, indexCorrect: 1)
		let answer2_4 = Answer(id: 14, questionID: 4, text: "N", isCorrect: nil, indexCorrect: 2)
		let answer3_4 = Answer(id: 15, questionID: 4, text: "O", isCorrect: nil, indexCorrect: 3)
		let answer4_4 = Answer(id: 16, questionID: 4, text: "P", isCorrect: nil, indexCorrect: 4)
		let question4 = Question(id: 4, examID: 1, type: .Puzzle, question: "mnop sdweoi  fosie  sodifeo sdfjoiwef sdfjoeiw soidfjwoeifsdf oiowf dfewf sdf sd\n sdfoewifsf sdfoiwef ?", photo: nil, answerList: [answer1_4, answer2_4, answer3_4, answer4_4])

		let question5 = Question(id: 5, examID: 1, type: .TextAnswer, question: "rsty sdweoi  fosie  sodifeo sdfjoiwef sdfjoeiw soidfjwoeifsdf oiowf?", photo: nil, answerList: nil)

		examHomeList = [Exam]()
		for i in 0...15 {
			let exam = Exam(id: i + 1, name: "Exam " + "\(i+1)", categoryID: 1, questionList: [question1, question2, question3, question4, question5])
			examHomeList.append(exam)
		}
	}

	func selectAnswer(answer: Answer, ofQuestion question: Question, ofExam exam: Exam) -> Exam {
		let newExam = exam.selectAnswer(answer, ofQuestion: question)
//		replaceExam(exam, withExam: newExam)
		return newExam
	}

	func unSelectAnswer(answer: Answer, ofQuestion question: Question, ofExam exam: Exam) -> Exam {
		let newExam = exam.unSelectAnswer(answer, ofQuestion: question)
//		replaceExam(exam, withExam: newExam)
		return newExam
	}

	func assingAnswer(answer: Answer, ofQuestion question: Question, ofExam exam: Exam, toIndex index: Int?) -> Exam {
		let newExam = exam.assignAnswer(answer, ofQuestion: question, atIndex: index)
//		replaceExam(exam, withExam: newExam)
		return newExam
	}

	func unassingAnswer(answer: Answer, ofQuestion question: Question, ofExam exam: Exam) -> Exam {
		let selectedIndexOrder = answer.indexSelected
//		var newExam = assingAnswer(answer, ofQuestion: question, ofExam: exam, toIndex: nil)
		var newExam = exam
		if let array = question.answerList?.filter({ $0.indexSelected != nil }) where array.count > 0 {
			for selectedAnswer in array {
				if selectedAnswer == answer {
					if let selectedQuestion = newExam.questionList.filter({ $0.id == question.id }).first {
						newExam = assingAnswer(selectedAnswer, ofQuestion: selectedQuestion, ofExam: newExam, toIndex: nil)
					}
				} else {
					if let index = selectedAnswer.indexSelected where index > selectedIndexOrder {
						if let selectedQuestion = newExam.questionList.filter({ $0.id == question.id }).first {
							newExam = assingAnswer(selectedAnswer, ofQuestion: selectedQuestion, ofExam: newExam, toIndex: (index - 1))
						}
					}
				}
			}
		}

		return newExam
	}

//	func resetExam(exam: Exam) -> Exam {
//		var newExam = exam
//		var count = 0
//		while count < exam.questionList.count {
//			let question = newExam.questionList[count]
//			if let answerList = question.answerList {
//				for answer in answerList {
//					if question.type == .OneChoose || question.type == .MultiChoose || question.type == .Photo {
//						newExam = unSelectAnswer(answer, ofQuestion: question, ofExam: newExam)
//					} else if question.type == .Puzzle {
//						newExam = unassingAnswer(answer, ofQuestion: question, ofExam: newExam)
//					}
//				}
//			}
//
//			count += 1
//		}
//		replaceExam(exam, withExam: newExam)
//		return newExam
//	}

	func replaceExam(exam: Exam, withExam newExam: Exam) {
		if let examIndex = examHomeList.indexOf({ $0.id == exam.id }) {
			examHomeList[examIndex] = newExam
		}
	}

}
