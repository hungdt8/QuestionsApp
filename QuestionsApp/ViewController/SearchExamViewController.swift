//
//  SearchExamViewController.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 11/6/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit
import SpeedLog

class SearchExamViewController: MainViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var isTheFirstShow = true
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = NSLocalizedString("Most", comment: "")
        
        self.view.bringSubviewToFront(searchBar)

//        tableView.dg_removePullToRefresh()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tableView.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
        searchBar.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = CGRect(x: 0, y: searchBar.frame.size.height, width: view.frame.size.width, height: view.frame.size.height - searchBar.frame.size.height)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if isSearching {
            arrayExam = dataHelper.resultSearchList
            tableView.reloadData()
        } else {
            if dataHelper.topExamList.count > 0 {
                reloadTopData()
            } else {
                startLoading()
                reloadDataFromServer()
            }
        }
        
//        if isTheFirstShow {
//            isTheFirstShow = false
//            searchBar.becomeFirstResponder()
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        SpeedLog.print("SEARCH EXAM VC DEALLOC")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - 
    func hideKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func reloadTopData() {
        arrayExam = dataHelper.topExamList
        tableView.reloadData()
    }
    
    func finishSearchProcess() {
        isSearching = false
        reloadTopData()
    }
    
    // MARK: - API Methods
    func requestSearchExamWithKeyword(keyword: String) {
        dataHelper.delegate = self
        dataHelper.searchExamViewKeyword(keyword)
    }
    
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

// MARK: - UISearchBarDelegate
extension SearchExamViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        hideKeyboard()
        
        if let keyword = searchBar.text where !keyword.isEmpty {
            showLoadingIndicator()
            
            dataHelper.resultSearchList.removeAll()
            requestSearchExamWithKeyword(keyword)
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        if !isSearching {
            isSearching = true
            arrayExam.removeAll()
            tableView.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            finishSearchProcess()
            return
        }
        
        if text.isEmpty {
            finishSearchProcess()
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        
        finishSearchProcess()
    }
}

// MARK: - DataHelperDelegate
extension SearchExamViewController: DataHelperDelegate {
    func searchExamSuccess() {
        endLoading()
        
        arrayExam = dataHelper.resultSearchList
        tableView.reloadData()
    }
    
    func searchExamFail(error: NSError?) {
        endLoading()
        showErrorAlert(error)
    }
    
    func getTopExamsSuccess() {
        arrayExam = dataHelper.topExamList
        tableView.reloadData()
        
        isFullData = true
//        if let paging = dataHelper.topPaging {
//            isFullData = paging.isFullData()
//        } else {
//            isFullData = true
//        }
        
        endLoading()
    }
    
    func getTopExamFail(error: NSError?) {
        endLoading()
        
        showErrorAlert(error)
    }
    
}
