//
//  HomeViewController.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 10/23/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit

class HomeViewController: MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        addSearchItemButtonWithSelector(#selector(self.showSearchExamScreen))
        
        screenGA = "Home Screen"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if dataHelper.homeExamList.count > 0 {
            arrayExam = dataHelper.homeExamList
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - API Methods
    func getHomeExamWithPage(page: Int? = nil) {
        dataHelper.delegate = self
        dataHelper.getHotExams(page)
    }
    
    override func reloadDataFromServer() {
        dataHelper.homeExamList.removeAll()
        getHomeExamWithPage()
    }
    
    override func loadMoreFromServer() {
        if let paging = dataHelper.homePaging {
            let page = paging.currentPage + 1
            isLoading = true
            getHomeExamWithPage(page)
        }
    }
}

extension HomeViewController: DataHelperDelegate {
    func getHotExamsSuccess() {
        arrayExam = dataHelper.homeExamList
        tableView.reloadData()
        
        if let paging = dataHelper.homePaging {
            isFullData = paging.isFullData()
        } else {
            isFullData = true
        }
        endLoading()
    }
    
    func getHotExamFail(error: NSError?) {
        endLoading()
        showErrorAlert(error)
    }
}

