//
//  APIInputs.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 10/23/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import Foundation

// MAKR: - Get Hot Exam
class GetHotExamInput: APIInputBase {
    var limit: Int
    var isHot: Int
    var page: Int?
    
    init(limit: Int = 20, isHot: Int = 1, page: Int? = nil) {
        self.limit = limit
        self.isHot = isHot
        self.page = page
        
        super.init()
        
        url = Constants.baseUrl + "Exam/loadExamToAll"
        requestType = .GET
        
        body = [
            "limit": self.limit,
            "isHot": self.isHot
        ]
        
        if let page = page {
            body!["page"] = page
        }
    }
}

enum GetHotExamResult {
    case success(exams: [Exam], paging: Paging?)
    case failure(error: NSError?)
}

// MAKR: - Get Top Exam
class GetTopExamInput: APIInputBase {
    var limit: Int
    var isTop: Int
    var page: Int?
    
    init(limit: Int = 20, isTop: Int = 1, page: Int? = nil) {
        self.limit = limit
        self.isTop = isTop
        self.page = page
        
        super.init()
        
        url = Constants.baseUrl + "Exam/loadExamToAll"
        requestType = .GET
        
        body = [
            "limit": self.limit,
            "isTop": self.isTop
        ]
        
        if let page = page {
            body!["page"] = page
        }
    }
}

enum GetTopExamResult {
    case success(exams: [Exam], paging: Paging?)
    case failure(error: NSError?)
}

// MAKR: - Get New Exam
class GetNewExamInput: APIInputBase {
    var limit: Int
    var isNew: Int
    var page: Int?
    
    init(limit: Int = 20, isNew: Int = 1, page: Int? = nil) {
        self.limit = limit
        self.isNew = isNew
        
        super.init()
        
        url = Constants.baseUrl + "Exam/loadExamToAll"
        requestType = .GET
        
        body = [
            "limit": self.limit,
            "isNew": self.isNew
        ]
        
        if let page = page {
            body!["page"] = page
        }
    }
}

enum GetNewExamResult {
    case success(exams: [Exam], paging: Paging?)
    case failure(error: NSError?)
}

// MAKR: - Get Exam Detail
class GetExamDetailInput: APIInputBase {
    var exam: Exam
    
    init(exam: Exam) {
        self.exam = exam
        
        super.init()
        
        url = Constants.baseUrl + "Question/LoadAllQuestionToExam"
        requestType = .GET
        
        body = [
            "idexam": "\(self.exam.id)"
        ]
    }
}

enum GetExamDetailResult {
    case success([Question])
    case failure(error: NSError?)
}

// MAKR: - Get Category
class GetCategoryInput: APIInputBase {
    var limit: Int
    var page: Int?
    
    init(limit: Int = 20, page: Int? = nil) {
        self.limit = limit
        self.page = page
        
        super.init()
        
        url = Constants.baseUrl + "Exam_Cate/loadCategory"
        requestType = .GET
        
        body = [
            "limit": self.limit,
        ]
        
        if let page = page {
            body!["page"] = page
        }
    }
}

enum GetCategoryResult {
    case success(categories: [ExamCategory], paging: Paging?)
    case failure(error: NSError?)
}

// MAKR: - Get Category Detail
class GetCategoryDetailInput: APIInputBase {
    var category: ExamCategory
    var limit: Int
    var page: Int?
    
    init(category: ExamCategory, limit: Int = 20, page: Int? = nil) {
        self.category = category
        self.limit = limit
        self.page = page
        
        super.init()
        
        url = Constants.baseUrl + "Exam/loadExamToAll"
        requestType = .GET
        
        body = [
            "idCate": "\(self.category.id)",
            "limit": self.limit
        ]
        
        if let page = page {
            body!["page"] = page
        }
    }
}

enum GetCategoryDetailResult {
    case success([Exam], paging: Paging?)
    case failure(error: NSError?)
}

// MAKR: - Search exam
class SearchExamInput: APIInputBase {
    var keyword: String
    var page: Int?
    
    init(keyword: String, page: Int? = nil) {
        self.keyword = keyword
        self.page = page
        
        super.init()
        
        url = Constants.baseUrl + "Search/Search"
        requestType = .GET
        
        body = [
            "search": self.keyword,
        ]
        
        if let page = page {
            body!["page"] = page
        }
    }
}

enum SearchExamResult {
    case success([Exam], paging: Paging?)
    case failure(error: NSError?)
}
