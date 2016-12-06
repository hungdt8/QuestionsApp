//
//  SearchExamViewControllerProtocol.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 11/6/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit

protocol SearchExamViewControllerProtocol: class {
    func addSearchItemButtonWithSelector(selector: Selector)
    func showSearchExamScreen()
}

extension SearchExamViewControllerProtocol where Self: UIViewController {
    func addSearchItemButtonWithSelector(selector: Selector) {
        let searchButton = UIBarButtonItem(image: UIImage(named: "search-icon"),
                                       style: UIBarButtonItemStyle.Plain ,
                                       target: self, action: selector)
        searchButton.tintColor = UIColor(hex: "68d705")
        
        self.navigationItem.rightBarButtonItem = searchButton
    }
}
