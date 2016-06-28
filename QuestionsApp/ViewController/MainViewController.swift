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

class MainViewController: ParentViewController {

	@IBOutlet weak var toolBar: UIToolbar!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var viewAnimation: SpringView!

	let segmentedControl = UISegmentedControl(items: [NSLocalizedString("Your's", comment: ""), NSLocalizedString("Home", comment: ""), NSLocalizedString("Most", comment: "")])
	var selectedCell: ExamCell?

	let transition = PopAnimator()

	var arrayExam = [Exam]()

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		title = NSLocalizedString("Question", comment: "")

		self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
		self.navigationController!.navigationBar.shadowImage = UIImage()

		segmentedControl.selectedSegmentIndex = 1

		toolBar.delegate = self
		let barbuttonItem = UIBarButtonItem(customView: segmentedControl)
		barbuttonItem.width = windowWidth() - 30.0
		toolBar.items = [barbuttonItem]

		viewAnimation?.hidden = true
		viewAnimation?.backgroundColor = UIColor.redColor()
		viewAnimation?.translatesAutoresizingMaskIntoConstraints = false
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

//		dataHelper.generateDummyContent()
		arrayExam = dataHelper.examHomeList
		tableView.reloadData()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: - Navigation

//	In a storyboard - based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showAnswerVCSegue" {
			selectedCell = sender as? ExamCell

			let answerVC = segue.destinationViewController as! AnswerViewController
			answerVC.transitioningDelegate = self
		}
	}
}

// MARK: - UIToolbarDelegate
extension MainViewController: UIToolbarDelegate {
	func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
		return .Top
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
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		SpeedLog.print(#function)

		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		selectedCell = tableView.cellForRowAtIndexPath(indexPath) as? ExamCell

		let exam = arrayExam[indexPath.row]
//		let resetExam = dataHelper.resetExam(exam)

		if let answerViewController = storyboard?.instantiateViewControllerWithIdentifier("AnswerVC") as? AnswerViewController {
			answerViewController.transitioningDelegate = self
			dataHelper.exam = exam
			answerViewController.dataHelper = dataHelper

			presentViewController(answerViewController, animated: true, completion: {

			})
		}
	}
}

// MARK: -	UIViewControllerTransitioningDelegate
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
