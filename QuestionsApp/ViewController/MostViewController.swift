//
//  MostViewController.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 10/29/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit

class MostViewController: MainViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        screenGA = "Most Screen"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if dataHelper.topExamList.count > 0 {
            arrayExam = dataHelper.topExamList
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
    func getTopExamWithPage(page: Int? = nil) {
        dataHelper.delegate = self
        dataHelper.getTopExams(page)
    }
    
    override func reloadDataFromServer() {
        dataHelper.topExamList.removeAll()
        getTopExamWithPage()
    }
    
    override func loadMoreFromServer() {
        if let paging = dataHelper.topPaging {
            let page = paging.currentPage + 1
            isLoading = true
            getTopExamWithPage(page)
        }
    }
}

//MARK: - DataHelperDelegate
extension MostViewController : DataHelperDelegate {
    func getTopExamsSuccess() {
        arrayExam = dataHelper.topExamList
        tableView.reloadData()
        
        if let paging = dataHelper.topPaging {
            isFullData = paging.isFullData()
        } else {
            isFullData = true
        }
        endLoading()
    }
    
    func getTopExamFail(error: NSError?) {
        endLoading()
        
        showErrorAlert(error)
    }
}

