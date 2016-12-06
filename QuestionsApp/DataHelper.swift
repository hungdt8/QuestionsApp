//
//  DataHelper.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 6/18/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import Foundation

@objc protocol DataHelperDelegate {
    optional func getHotExamsSuccess()
    optional func getHotExamFail(error: NSError?)
    
    optional func getTopExamsSuccess()
    optional func getTopExamFail(error: NSError?)
    
    optional func getNewExamsSuccess()
    optional func getNewExamFail(error: NSError?)
    
    optional func getExamDetailSuccess()
    optional func getExamDetailFail(error: NSError?)
    
    optional func getCategoriesSuccess()
    optional func getCategoriesFail(error: NSError?)
    
    optional func getCategoryDetailSuccess()
    optional func getCategoryDetailFail(error: NSError?)
    
    optional func searchExamSuccess()
    optional func searchExamFail(error: NSError?)
}

class DataHelper : NSObject {
    var homeExamList = [Exam]()
    var homePaging: Paging?
    
    var topExamList = [Exam]()
    var topPaging: Paging?
    
    var yourExamList = [Exam]()
    
    var newExamList = [Exam]()
    var newPaging: Paging?
    
    var resultSearchList = [Exam]()
    var resultSearchPaging: Paging?
    
    var categoryList = [ExamCategory]()
    var categoryPaging: Paging?
    
    var examListCatogory = [Exam]()
    var detailCateogryPaging: Paging?
    
    var exam: Exam!
    
    let apiService = APIService()
    
    weak var delegate: DataHelperDelegate?
    
    override init() {
        //		generateDummyContent()
    }
    
    func generateDummyContent() {
        let answer1_1 = Answer(id: 1, questionID: 1, text: "A", isCorrect: true, indexCorrect: nil)
        let answer2_1 = Answer(id: 2, questionID: 1, text: "B", isCorrect: false, indexCorrect: nil)
        let answer3_1 = Answer(id: 3, questionID: 1, text: "C", isCorrect: false, indexCorrect: nil)
        let answer4_1 = Answer(id: 4, questionID: 1, text: "D", isCorrect: false, indexCorrect: nil)
        let question1 = Question(id: 1, examID: 1, type: .OneChoose, question: "abcd sdweoi  fosie  sodifeo sdfjoiwef sdfjoeiw soidfjwoeifsdf oiowf?", photo: nil, order: 0, answerList: [answer1_1, answer2_1, answer3_1, answer4_1])
        
        let answer1_2 = Answer(id: 5, questionID: 2, text: "E", isCorrect: true, indexCorrect: nil)
        let answer2_2 = Answer(id: 6, questionID: 2, text: "F", isCorrect: true, indexCorrect: nil)
        let answer3_2 = Answer(id: 7, questionID: 2, text: "G", isCorrect: false, indexCorrect: nil)
        let answer4_2 = Answer(id: 8, questionID: 2, text: "H", isCorrect: false, indexCorrect: nil)
        let question2 = Question(id: 2, examID: 1, type: .MultiChoose, question: "efgh sdweoi  fosie  sodifeo sdfjoiwef sdfjoeiw soidfjwoeifsdf oiowf?", photo: nil, order: 1, answerList: [answer1_2, answer2_2, answer3_2, answer4_2])
        
        let answer1_3 = Answer(id: 9, questionID: 3, text: "I", isCorrect: true, indexCorrect: nil)
        let answer2_3 = Answer(id: 10, questionID: 3, text: "J", isCorrect: false, indexCorrect: nil)
        let answer3_3 = Answer(id: 11, questionID: 3, text: "K", isCorrect: false, indexCorrect: nil)
        let answer4_3 = Answer(id: 12, questionID: 3, text: "L", isCorrect: false, indexCorrect: nil)
        let question3 = Question(id: 3, examID: 1, type: .Photo, question: "ijkl sdweoi?", photo: "a.png", order: 2, answerList: [answer1_3, answer2_3, answer3_3, answer4_3])
        
        let answer1_4 = Answer(id: 13, questionID: 4, text: "Msdf dsfwe", isCorrect: nil, indexCorrect: 1)
        let answer2_4 = Answer(id: 14, questionID: 4, text: "N11 2", isCorrect: nil, indexCorrect: 2)
        let answer3_4 = Answer(id: 15, questionID: 4, text: "O 21", isCorrect: nil, indexCorrect: 3)
        let answer4_4 = Answer(id: 16, questionID: 4, text: "P 312", isCorrect: nil, indexCorrect: 4)
        let answer5_4 = Answer(id: 17, questionID: 4, text: "L dsfs sdfsd", isCorrect: nil, indexCorrect: 5)
        let answer6_4 = Answer(id: 18, questionID: 4, text: "98 sdsfes sef", isCorrect: nil, indexCorrect: 6)
        let answer7_4 = Answer(id: 19, questionID: 4, text: "2 sdsfes sef", isCorrect: nil, indexCorrect: 7)
        //		let answer8_4 = Answer(id: 20, questionID: 4, text: "7 sdsfes sef", isCorrect: nil, indexCorrect: 8)
        //		let answer9_4 = Answer(id: 21, questionID: 4, text: "1 sdsfes sef", isCorrect: nil, indexCorrect: 9)
        let question4 = Question(id: 4, examID: 1, type: .Puzzle, question: "mnop sdweoi  fosie  sodifeo sdfjoiwef sdfjoeiw soidfjwoeifsdf oiowf dfewf sdf sd\n sdfoewifsf sdfoiwef ?", photo: nil, order: 3, answerList: [answer1_4, answer2_4, answer3_4, answer4_4, answer5_4, answer6_4, answer7_4])
        
        let question5 = Question(id: 5, examID: 1, type: .TextAnswer, question: "rsty sdweoi  fosie  sodifeo sdfjoiwef sdfjoeiw soidfjwoeifsdf oiowf?", photo: nil, order: 4, answerList: nil)
        
        homeExamList = [Exam]()
        for i in 0...15 {
            let exam = Exam(id: i + 1, name: "Exam " + "\(i+1)", categoryID: 1, questionList: [question4, question1, question2, question3, question5], isRandom: false)
            homeExamList.append(exam)
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
    //	}}
    
    func updateAnswerText(string: String, ofQuestion question: Question, ofExam exam: Exam) -> Exam {
        return exam.updateAnswerText(string, ofQuestion: question)
        
    }
    
    func replaceExam(exam: Exam, withExam newExam: Exam) {
        if let examIndex = homeExamList.indexOf({ $0.id == exam.id }) {
            homeExamList[examIndex] = newExam
        }
    }
}

// MARK: - API Methods
extension DataHelper {
    func getHotExams(page: Int? = nil) {
        let input = GetHotExamInput(page: page)
        apiService.getHotExams(input) { (result) in
            switch result{
            case .success(let exams, let paging):
                self.homePaging = paging
                self.homeExamList.appendContentsOf(exams)
                self.delegate?.getHotExamsSuccess?()
                break
            case .failure(let error):
                self.delegate?.getHotExamFail?(error)
                break
            }
        }
    }
    
    func getTopExams(page: Int? = nil) {
        let input = GetTopExamInput(page: page)
        apiService.getTopExams(input) { (result) in
            switch result{
            case .success(let exams, let paging):
                self.topPaging = paging
                self.topExamList.appendContentsOf(exams)
                self.delegate?.getTopExamsSuccess?()
                break
            case .failure(let error):
                self.delegate?.getTopExamFail?(error)
                break
            }
        }
    }
    
    func getNewExams(page: Int? = nil) {
        let input = GetNewExamInput(page: page)
        apiService.getNewExams(input) { (result) in
            switch result{
            case .success(let exams, let paging):
                self.newPaging = paging
                self.newExamList.appendContentsOf(exams)
                self.delegate?.getNewExamsSuccess?()
                break
            case .failure(let error):
                self.delegate?.getNewExamFail?(error)
                break
            }
        }
    }
    
    func getDetailExam(exam: Exam) {
        let input = GetExamDetailInput(exam: exam)
        apiService.getExamDetail(input) { (result) in
            switch result {
            case .success(let questions):
                var updatedExam = exam
                updatedExam.questionList = questions
                
                self.exam = updatedExam
                self.delegate?.getExamDetailSuccess?()
                break
            case .failure(let error):
                self.delegate?.getExamDetailFail?(error)
                break
            }
        }
    }
    
    func getCategories(page: Int? = nil) {
        let input = GetCategoryInput(limit: 10, page: page)
        apiService.getCategories(input) { (result) in
            switch result {
            case .success(let categories, let paging):
                self.categoryPaging = paging
                self.categoryList.appendContentsOf(categories)
                self.delegate?.getCategoriesSuccess?()
                break
            case .failure(let error):
                self.delegate?.getCategoriesFail?(error)
                break
            }
        }
    }
    
    func getCategoryDetail(category: ExamCategory, page: Int? = nil) {
        let input = GetCategoryDetailInput(category: category, page: page)
        apiService.getCategoryDetail(input) { (result) in
            switch result{
            case .success(let exams, let paging):
                self.detailCateogryPaging = paging
                self.examListCatogory.appendContentsOf(exams)
                self.delegate?.getCategoryDetailSuccess?()
                break
            case .failure(let error):
                self.delegate?.getCategoryDetailFail?(error)
                break
            }
        }
    }
    
    func searchExamViewKeyword(keyword: String, page: Int? = nil) {
        let input = SearchExamInput(keyword: keyword, page: page)
        apiService.searchExam(input) { (result) in
            switch result {
            case .success(let exams, let paging):
                self.resultSearchPaging = paging
                self.resultSearchList.appendContentsOf(exams)
                self.delegate?.searchExamSuccess?()
                break
            case .failure(let error):
                self.delegate?.searchExamFail?(error)
                break
            }
        }
    }
}

//MARK: - DB
extension DataHelper {
    func saveContext() {
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    func saveExamToDB(exam: Exam) {
        if let examEntity = ExamEntity.MR_findFirstWithPredicate(NSPredicate(format: "id = %d", exam.id)) {
            examEntity.MR_deleteEntity()
        }
        
        if let examEntity = ExamEntity.MR_createEntity() {
            examEntity.name = exam.name
            examEntity.id = Int64(exam.id)
            examEntity.categoryId = Int64(exam.categoryID)
            examEntity.isRandom = exam.isRandom
            for question in exam.questionList {
                if let questionEntity = QuestionEntity.MR_createEntity() {
                    questionEntity.id = Int64(question.id)
                    questionEntity.question = question.question
                    //                questionEntity?.examID = Int64(question.examID)
                    questionEntity.type = Int16(question.type.rawValue)
                    questionEntity.photo = question.photo
                    if let order = question.order {
                        questionEntity.order = Int16(order)
                    }
                    questionEntity.answerText = question.answerText
                    
                    if let answerList = question.answerList {
                        for anwser in answerList {
                            if let answerEntity = AnswerEntity.MR_createEntity() {
                                answerEntity.id = Int64(anwser.id)
                                answerEntity.text = anwser.text
                                if let isCorrect = anwser.isCorrect {
                                    answerEntity.isCorrect = isCorrect
                                }
                                if let indexCorrect = anwser.indexCorrect {
                                    answerEntity.indexCorrect = Int16(indexCorrect)
                                }
                                answerEntity.isSelected = anwser.isSelected
                                if let indexSelected = anwser.indexSelected {
                                    answerEntity.indexSelected = Int16(indexSelected)
                                }
                                
                                questionEntity.addToAnswerList(answerEntity)
                            }
                        }
                    }
                    
                    examEntity.addToQuestionList(questionEntity)
                }
            }
            
            self.saveContext()
        }
    }
    
    func getSavedExamFromDB() {
        yourExamList.removeAll()
        if let array = ExamEntity.MR_findAll()?.reverse() {
            for examEntity in array {
                let exam = Exam(examEntity: examEntity as! ExamEntity)
                yourExamList.append(exam)
            }
        }
    }
}
