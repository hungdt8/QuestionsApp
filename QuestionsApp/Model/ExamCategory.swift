//
//  ExamCategory.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 6/7/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import Foundation
import ObjectMapper

struct ExamCategory:Mappable {
	var id: Int = 0
	var name: String = ""
	var examList: [Exam]?
    var image: String?
    
    init?(_ map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id     <- map["IdCate"]
        name  <- map["NameCate"]
        image <- map["Image"]
    }
}
