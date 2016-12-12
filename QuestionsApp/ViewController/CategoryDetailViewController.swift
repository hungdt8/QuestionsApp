//
//  CategoryDetailViewController.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 10/30/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit
import SpeedLog

class CategoryDetailViewController: MainViewController {

    var category: ExamCategory!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = category.name
        
        screenGA = "Category Detail Screen"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if dataHelper.examListCatogory.count > 0 {
            arrayExam = dataHelper.examListCatogory
            tableView.reloadData()
        } else {
            startLoading()
            reloadDataFromServer()
        }
        
        sendScreenNameGA(screenGA)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        //reset data
        dataHelper.examListCatogory.removeAll()
        
        SpeedLog.print("CategoryDetailViewController DEALLOC")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - API Methods
    func getCategoryDetailWithPage(page: Int? = nil) {
        dataHelper.delegate = self
        dataHelper.getCategoryDetail(category, page: page)
    }
    
    override func reloadDataFromServer() {
        dataHelper.examListCatogory.removeAll()
        getCategoryDetailWithPage()
    }
    
    override func loadMoreFromServer() {
        if let paging = dataHelper.detailCateogryPaging {
            let page = paging.currentPage + 1
            isLoading = true
            getCategoryDetailWithPage(page)
        }
    }
}

//MARK: - DataHelperDelegate
extension CategoryDetailViewController : DataHelperDelegate {
    func getCategoryDetailSuccess() {
        arrayExam = dataHelper.examListCatogory
        tableView.reloadData()
        
        if let paging = dataHelper.detailCateogryPaging {
            isFullData = paging.isFullData()
        } else {
            isFullData = true
        }
        
        endLoading()
    }
    
    func getCategoryDetailFail(error: NSError?) {
        endLoading()
        
        showErrorAlert(error)
    }
}
