//
//  Paging.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 11/6/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit
import ObjectMapper

class Paging: NSObject, Mappable {
    var currentPage: Int = 0
    var lastPage: Int = 0
    var from: Int = 0
    var to: Int = 0
    var nextPageUrl: String = ""
    var previousPageUrl: String = ""
    var perPage: Int = 0
    var total: Int = 0
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        currentPage <- map["current_page"]
        lastPage <- map["last_page"]
        from <- map["from"]
        to <- map["to"]
        nextPageUrl <- map["next_page_url"]
        previousPageUrl <- map["prev_page_url"]
        perPage <- map["per_page"]
        total <- map["total"]
    }
    
    func isFullData() -> Bool {
        if nextPageUrl.isEmpty {
            return true
        } else {
            return false
        }
    }
}
