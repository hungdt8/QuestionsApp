//
//  APIService.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 10/23/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftyJSON
import  SpeedLog

class APIService: NSObject {
    var alamoFireManager = Alamofire.Manager.sharedInstance
    
    override init() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForResource = 30
        configuration.timeoutIntervalForRequest = 30
        alamoFireManager = Alamofire.Manager(configuration: configuration)
    }
    
    private func request(input: APIInputBase, completion: (value: AnyObject?, error: NSError?) -> Void) {
        alamoFireManager.request(input.requestType, input.url, headers: input.headers, parameters: input.body, encoding: input.encoding)
            .validate(statusCode: 200..<500)
            .responseJSON { response in
                print(response.request?.URLString)
                print(response)
                switch response.result {
                case .Success(let value):
                    guard let statusCode = response.response?.statusCode where statusCode == 200 else {
                        completion(value: nil, error:nil)
                        return
                    }
                    completion(value: value, error:nil)
                    break
                case .Failure(let error):
                    completion(value: nil, error: error)
                    break
                }
        }
    }
}

extension APIService {
    func getHotExams(input: GetHotExamInput, completion: (result: GetHotExamResult) -> Void) {
        request(input) { (value, error) in
            guard let value = value as? [String: AnyObject] else {
                completion(result: GetHotExamResult.failure(error: error))
                return
            }
            guard let arrayData = value[Constants.Key.data] as? [[String: AnyObject]] else {
                completion(result: GetHotExamResult.failure(error: error))
                return
            }
            var exams = [Exam]()
            for data in arrayData {
                if let exam = Exam(JSON: data) {
                    exams.append(exam)
                }
            }
            
            let paging = Paging(JSON: value)
            completion(result: GetHotExamResult.success(exams: exams, paging: paging))
        }
    }
    
    func getTopExams(input: GetTopExamInput, completion: (result: GetTopExamResult) -> Void) {
        request(input) { (value, error) in
            guard let value = value as? [String: AnyObject] else {
                completion(result: GetTopExamResult.failure(error: error))
                return
            }
            guard let arrayData = value[Constants.Key.data] as? [[String: AnyObject]] else {
                completion(result: GetTopExamResult.failure(error: error))
                return
            }
            var exams = [Exam]()
            for data in arrayData {
                if let exam = Exam(JSON: data) {
                    exams.append(exam)
                }
            }
            
            let paging = Paging(JSON: value)
            completion(result: GetTopExamResult.success(exams: exams,paging: paging))
        }
    }
    
    func getNewExams(input: GetNewExamInput, completion: (result: GetNewExamResult) -> Void) {
        request(input) { (value, error) in
            guard let value = value as? [String: AnyObject] else {
                completion(result: GetNewExamResult.failure(error: error))
                return
            }
            guard let arrayData = value[Constants.Key.data] as? [[String: AnyObject]] else {
                completion(result: GetNewExamResult.failure(error: error))
                return
            }
            var exams = [Exam]()
            for data in arrayData {
                if let exam = Exam(JSON: data) {
                    exams.append(exam)
                }
            }
            let paging = Paging(JSON: value)
            completion(result: GetNewExamResult.success(exams: exams,paging: paging))
        }
    }
    
    func getExamDetail(input: GetExamDetailInput, completion:(result: GetExamDetailResult) -> Void) {
        request(input) { (value, error) in
            guard let arrayData = value as? [[String: AnyObject]] else {
                completion(result: GetExamDetailResult.failure(error: error))
                return
            }
            
            var questions = [Question]()
            for data in arrayData {
                if let question = Question(JSON: data) {
                    questions.append(question)
                }
            }
            completion(result: GetExamDetailResult.success(questions))
        }
    }
    
    func getCategories(input: GetCategoryInput, completion: (result: GetCategoryResult) -> Void) {
        request(input) { (value, error) in
            guard let value = value as? [String: AnyObject] else {
                completion(result: GetCategoryResult.failure(error: error))
                return
            }
            guard let arrayData = value[Constants.Key.data] as? [[String: AnyObject]] else {
                completion(result: GetCategoryResult.failure(error: error))
                return
            }
            var categories = [ExamCategory]()
            for data in arrayData {
                if let category = ExamCategory(JSON: data) {
                    categories.append(category)
                }
            }
            let paging = Paging(JSON: value)
            completion(result: GetCategoryResult.success(categories: categories,paging: paging))
        }
    }
    
    func getCategoryDetail(input: GetCategoryDetailInput, completion: (result: GetCategoryDetailResult) -> Void) {
        request(input) { (value, error) in
            guard let value = value as? [String: AnyObject] else {
                completion(result: GetCategoryDetailResult.failure(error: error))
                return
            }
            guard let arrayData = value[Constants.Key.data] as? [[String: AnyObject]] else {
                completion(result: GetCategoryDetailResult.failure(error: error))
                return
            }
            var exams = [Exam]()
            for data in arrayData {
                if let exam = Exam(JSON: data) {
                    exams.append(exam)
                }
            }
            let paging = Paging(JSON: value)
            completion(result: GetCategoryDetailResult.success(exams,paging: paging))
        }
    }
    
    func searchExam(input: SearchExamInput, completion: (result: SearchExamResult) -> Void) {
        request(input) { (value, error) in
            guard let value = value as? [String: AnyObject] else {
                completion(result: SearchExamResult.failure(error: error))
                return
            }
            guard let arrayData = value[Constants.Key.data] as? [[String: AnyObject]] else {
                completion(result: SearchExamResult.failure(error: error))
                return
            }
            var exams = [Exam]()
            for data in arrayData {
                if let exam = Exam(JSON: data) {
                    exams.append(exam)
                }
            }
            let paging = Paging(JSON: value)
            completion(result: SearchExamResult.success(exams,paging: paging))
        }
    }
}
