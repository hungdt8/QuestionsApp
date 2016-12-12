//
//  GAProtocol.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 12/7/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import Foundation

protocol GAProtocol {
    func sendScreenNameGA(name: String)
    func logGAShowExamFrom(screen: String)
    func logGASearchKeyword(keyword: String)
}

extension GAProtocol {
    func sendScreenNameGA(name: String) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: name)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject: AnyObject])
    }
    
    func logGAShowExamFrom(screen: String) {
        let tracker = GAI.sharedInstance().defaultTracker
        let builder = GAIDictionaryBuilder.createEventWithCategory("Show Exam From", action: screen, label: nil, value: nil)
        tracker.send(builder.build() as [NSObject: AnyObject])
    }
    
    func logGASearchKeyword(keyword: String) {
        let tracker = GAI.sharedInstance().defaultTracker
        let builder = GAIDictionaryBuilder.createEventWithCategory("Search Exam", action: keyword, label: nil, value: nil)
        tracker.send(builder.build() as [NSObject: AnyObject])
    }
}
