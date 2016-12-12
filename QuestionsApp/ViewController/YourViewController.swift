//
//  YourViewController.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 10/29/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit

class YourViewController: MainViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.registerNib(UINib(nibName: "YourExamCell", bundle: nil), forCellReuseIdentifier: "YourExamCell")
        tableView.dg_removePullToRefresh()
        
        isFullData = true
        endLoading()
        
        screenGA = "Yours Screen"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        dataHelper.getSavedExamFromDB()
        arrayExam = dataHelper.yourExamList
        tableView.reloadData()
        
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
    func getNewExamWithPage(page: Int? = nil) {
        dataHelper.delegate = self
        dataHelper.getNewExams(page)
    }
    
    override func reloadDataFromServer() {
        dataHelper.newExamList.removeAll()
        getNewExamWithPage()
    }
    
    override func loadMoreFromServer() {
        if let paging = dataHelper.newPaging {
            let page = paging.currentPage + 1
            isLoading = true
            getNewExamWithPage(page)
        }
    }
}

// MARK: - UITableViewDatasource
extension YourViewController {
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("YourExamCell", forIndexPath: indexPath) as! YourExamCell
        
        let exam = arrayExam[indexPath.row]
        cell.labelTtitle.text = exam.name
//        cell.progressBar.progress = exam.getProgress()
        cell.progressLabel.text = exam.getProgressString()
        
        return cell
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let exam = arrayExam[indexPath.row]
            if let examEntity = ExamEntity.MR_findFirstWithPredicate(NSPredicate(format: "id = %d", exam.id)) {
                examEntity.MR_deleteEntity()
            }
            
            dataHelper.getSavedExamFromDB()
            arrayExam = dataHelper.yourExamList
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
}

// MARK: - DataHelperDelegate
extension YourViewController: DataHelperDelegate {
    func getNewExamsSuccess() {
        arrayExam = dataHelper.newExamList
        tableView.reloadData()
        
        if let paging = dataHelper.newPaging {
            isFullData = paging.isFullData()
        } else {
            isFullData = true
        }
        endLoading()
    }
    
    func getNewExamFail(error: NSError?) {
        endLoading()
        showErrorAlert(error)
    }
}
