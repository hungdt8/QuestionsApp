//
//  APIInputBase.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 10/23/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit
import Alamofire

class APIInputBase: NSObject {
    var url = ""
    
    var requestType = Alamofire.Method.GET
    var body: [String: AnyObject]?
    var headers = ["Content-Type": "application/json; charset=utf-8"]
    
    var encoding: ParameterEncoding {
        switch requestType {
        case .GET:
            return .URLEncodedInURL
        default:
            return .JSON
        }
    }
    
    var usingAccessToken = true
    
    func setup(url: String, requestType: Alamofire.Method, usingAccessToken: Bool) {
        self.url = url
        self.requestType = requestType
        self.usingAccessToken = usingAccessToken
    }
}
