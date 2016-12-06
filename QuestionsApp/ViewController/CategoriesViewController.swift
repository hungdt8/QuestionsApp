//
//  CategoriesViewController.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 10/30/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit
import SpeedLog
import DGElasticPullToRefresh

class CategoriesViewController: ParentViewController {

    var tableView: UITableView!
    let loadMoreView = LoadMoreFooterView.instanceFromNib()
    
    var isFullData: Bool = false {
        didSet {
            if isFullData {
                hideLoadMoreView()
            } else {
                showLoadMoreView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = NSLocalizedString("Category", comment: "")
        
        tableView = UITableView(frame: view.bounds, style: .Plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        tableView.separatorColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 231/255.0, alpha: 1.0)
        tableView.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 251/255.0, alpha: 1.0)
        tableView.separatorStyle = .None
        view.addSubview(tableView)
        
        tableView.registerNib(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "CategoryCell")
        
        addPullRefreshTableView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if dataHelper.categoryList.isEmpty {
            startLoading()
            reloadDataFromServer()
        } else {
            tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCategoryDetail" {
            if let detailCategoryViewController = segue.destinationViewController as? CategoryDetailViewController {
                let row = (sender as! NSIndexPath).row
                let category = dataHelper.categoryList[row]
                
                detailCategoryViewController.dataHelper = dataHelper
                detailCategoryViewController.category = category
            }
        }
    }
    
    
    // MARK: - API
    func reloadDataFromServer() {
        dataHelper.categoryList.removeAll()
        getCategoriesWithPage()
    }
    
    func getCategoriesWithPage(page: Int? = nil) {
        dataHelper.delegate = self
        dataHelper.getCategories(page)
    }
    
    func loadMoreFromServer() {
        if let paging = dataHelper.categoryPaging {
            let page = paging.currentPage + 1
            isLoading = true
            getCategoriesWithPage(page)
        }
    }
    
    // MARK: - Method
    func addPullRefreshTableView() {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            if self?.isLoading == false {
                self?.reloadDataFromServer()
            }
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
    
    override func endLoading() {
        super.endLoading()
        
        tableView.dg_stopLoading()
    }
    
    func showLoadMoreView() {
        tableView.tableFooterView = loadMoreView
        loadMoreView.hidden = false
    }
    
    func hideLoadMoreView() {
        tableView.tableFooterView = nil
        loadMoreView.hidden = true
    }
}

// MARK: - UITableViewDataSource
extension CategoriesViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataHelper.categoryList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) as! CategoryCell
        
        let category = dataHelper.categoryList[indexPath.row]
        cell.category = category
        
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if !isLoading && !isFullData {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            
            if offsetY > contentHeight - scrollView.frame.size.height - 50 {
                print("load more")
                loadMoreFromServer()
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension CategoriesViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.performSegueWithIdentifier("showCategoryDetail", sender: indexPath)
    }
}

// MARK: - DataHelperDelegate
extension CategoriesViewController: DataHelperDelegate {
    func getCategoriesSuccess() {
        tableView.reloadData()
        
        if let paging = dataHelper.categoryPaging {
            isFullData = paging.isFullData()
        } else {
            isFullData = true
        }
        
        endLoading()
    }
    
    func getCategoriesFail(error: NSError?) {
        endLoading()
        
        showErrorAlert(error)
    }
}
