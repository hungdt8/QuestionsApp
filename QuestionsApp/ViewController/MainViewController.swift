//
//  MainViewController.swift
//  QuestionsApp
//
//  Created by Hungld on 5/29/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit
import Spring
import SpeedLog
import DGElasticPullToRefresh

class MainViewController: ParentViewController {

	@IBOutlet weak var viewAnimation: SpringView!
    let loadMoreView = LoadMoreFooterView.instanceFromNib()
    
    var tableView: UITableView!

	var selectedCell: ExamCell?

	let transition = PopAnimator()

	var arrayExam = [Exam]()
    
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
//		title = NSLocalizedString("Question", comment: "")

//		self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
//		self.navigationController!.navigationBar.shadowImage = UIImage()

		viewAnimation?.hidden = true
		viewAnimation?.backgroundColor = UIColor.redColor()
		viewAnimation?.translatesAutoresizingMaskIntoConstraints = false
        
        tableView = UITableView(frame: view.bounds, style: .Plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        tableView.separatorColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 231/255.0, alpha: 1.0)
        tableView.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 251/255.0, alpha: 1.0)
        view.addSubview(tableView)
        tableView.keyboardDismissMode = .OnDrag
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        tableView.registerNib(UINib(nibName: "ExamCell", bundle: nil), forCellReuseIdentifier: "ExamCell")
        
        addPullRefreshTableView()
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

//		arrayExam = dataHelper.homeExamList
		tableView.reloadData()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

    deinit {
        tableView.dg_removePullToRefresh()
    }
    
	// MARK: - Navigation

//	In a storyboard - based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showAnswerVCSegue" {
			selectedCell = sender as? ExamCell

			let answerVC = segue.destinationViewController as! AnswerViewController
			answerVC.transitioningDelegate = self
        } else if segue.identifier == "showSearchExamSegue" {
            let searchExamViewController = segue.destinationViewController as! SearchExamViewController
            searchExamViewController.dataHelper = dataHelper
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
    
    func reloadDataFromServer() {
        
    }
    
    func loadMoreFromServer() {
        
    }
    
    func showLoadMoreView() {
        tableView.tableFooterView = loadMoreView
    }
    
    func hideLoadMoreView() {
        tableView.tableFooterView = nil
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return arrayExam.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("ExamCell", forIndexPath: indexPath) as! ExamCell

		let exam = arrayExam[indexPath.row]
		cell.labelTtitle.text = exam.name

		return cell
	}
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 50
        return UITableViewAutomaticDimension
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
extension MainViewController: UITableViewDelegate {
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		selectedCell = tableView.cellForRowAtIndexPath(indexPath) as? ExamCell

		let exam = arrayExam[indexPath.row]

		if let answerViewController = storyboard?.instantiateViewControllerWithIdentifier("AnswerVC") as? AnswerViewController {
			answerViewController.transitioningDelegate = self
			dataHelper.exam = exam
			answerViewController.dataHelper = dataHelper

			presentViewController(answerViewController, animated: true, completion: {

			})
		}
	}
}

// MARK: - UIViewControllerTransitioningDelegate
extension MainViewController: UIViewControllerTransitioningDelegate {
	func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

		transition.viewAnimation = viewAnimation
		transition.originFrame = selectedCell!.convertRect(view.frame, toView: nil)
		transition.presenting = true

		return transition
	}

	func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		transition.presenting = false
		return transition
	}
}
