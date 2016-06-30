//
//  AnswerViewController.swift
//  QuestionsApp
//
//  Created by Hungld on 5/30/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit
import SpeedLog
import ChameleonFramework
import Spring

class AnswerViewController: ParentViewController, NVActivityIndicatorViewable {

	@IBOutlet weak var buttonCheck: UIButton!
	@IBOutlet weak var buttonClose: UIButton!
	@IBOutlet weak var viewShowResult: ViewResult!
	@IBOutlet weak var progressView: UIProgressView!
	@IBOutlet weak var bottomConstraintViewShowResult: NSLayoutConstraint!
	@IBOutlet weak var leadingConstraintViewShowResult: NSLayoutConstraint!
	@IBOutlet weak var heightConstraintViewShowResult: NSLayoutConstraint!
	@IBOutlet weak var bottomConstraintButtonCheck: NSLayoutConstraint!
	let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: NVActivityIndicatorType.BallPulse)

	var currentViewQuestion: ViewQuestion?

	let alphaViewResultWhenSelect: CGFloat = 0.5
	let defaultBottomConstraintViewResult: CGFloat = 115.0

	var heightViewResult: CGFloat! = windowHeight()
	var widthViewResult: CGFloat! = windowWidth()

	var isAnswered = false
	var indexQuestion = 0

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		view.backgroundColor = Constants.Color.colorBackgroundQuestionView

		buttonCheck.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		buttonCheck.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
		buttonCheck.layer.cornerRadius = 25.0
		buttonCheck.layer.masksToBounds = true

		viewShowResult.delegate = self

		let panGestureViewShowResult = UIPanGestureRecognizer(target: self, action: #selector(AnswerViewController.handlePanGestureViewResult(_:)))
		viewShowResult.addGestureRecognizer(panGestureViewShowResult)
		panGestureViewShowResult.delegate = self

		let tapGestureViewShowResult = UILongPressGestureRecognizer(target: self, action: #selector(AnswerViewController.handleTapGestureViewResult(_:)))
		viewShowResult.addGestureRecognizer(tapGestureViewShowResult)
		tapGestureViewShowResult.minimumPressDuration = 0.0
		tapGestureViewShowResult.delegate = self

		let tap = UITapGestureRecognizer(target: self, action: #selector(AnswerViewController.resignTextView))
		tap.cancelsTouchesInView = false
		tap.delegate = self
		self.view.addGestureRecognizer(tap)

		progressView.progress = 0
		progressView.tintColor = Constants.Color.colorProgsressAnswer

		self.view.addSubview(indicator)

		disableButtonCheck()

		layoutBeforeAnswerQuestion()

		bottomConstraintViewShowResult.constant = defaultBottomConstraintViewResult
		viewShowResult.hidden = true

		let question = dataHelper.exam.questionList[indexQuestion]
		currentViewQuestion = viewQuestionWithQuesion(question)
		showViewQuestion(currentViewQuestion!)

		hideAllSubviews()
		showLoadingIndicator()
		let delay = 2000.0
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_MSEC))), dispatch_get_main_queue()) {
			self.showAllSubviews()
			self.hideLoadingIndicator()
		}
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AnswerViewController.handleKeyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AnswerViewController.handleKeyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
	}

	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)

		NSNotificationCenter.defaultCenter().removeObserver(self)
		hideAllSubviews()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		widthViewResult = CGRectGetWidth(viewShowResult.frame)
		heightViewResult = CGRectGetHeight(viewShowResult.frame)

		indicator.center = self.view.center
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	deinit {
		SpeedLog.print("ANSWER VC DEALLOC")
	}

	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.

		if let destinationViewController = segue.destinationViewController as? ResultViewController {
			destinationViewController.dataHelper = dataHelper
		}
	}

	// MARK: - Methods
	func activeButtonCheck() {
		buttonCheck.enabled = true
		buttonCheck.alpha = 1.0
		buttonCheck.backgroundColor = Constants.Color.colorActiveButtonCheck
	}

	func disableButtonCheck() {
		buttonCheck.enabled = false
		buttonCheck.alpha = 0.9
		buttonCheck.backgroundColor = Constants.Color.colorDisableButtonCheck
	}

	func layoutBeforeAnswerQuestion() {
		buttonCheck.setTitle(NSLocalizedString("Check", comment: ""), forState: .Normal)
	}

	func layoutAnsweringQuestion() {
		buttonCheck.setTitle(NSLocalizedString("Checking...", comment: ""), forState: .Normal)
	}

	func layoutAfterAnswerQuestion() {
		buttonCheck.setTitle(NSLocalizedString("Next", comment: ""), forState: .Normal)
	}

	func showViewResultWithResult(result: Result) {
		/*bottomConstraintViewShowResult.constant = defaultBottomConstraintViewResult
		 UIView.animateWithDuration(0.15, delay: 0.0, options: .CurveEaseOut,
		 animations: {
		 self.view.layoutIfNeeded()
		 self.viewShowResult.alpha = 1.0
		 }, completion: { _ in

		 })*/

		switch result {
		case .Right:
			viewShowResult.layoutRightState()
			break
		case .Wrong:
			viewShowResult.rightAnswer = currentViewQuestion?.question.getRightTextAnswer()
			viewShowResult.layoutWrongState()
			break
		}

		leadingConstraintViewShowResult.constant = 0
		bottomConstraintViewShowResult.constant = defaultBottomConstraintViewResult
		self.view.layoutIfNeeded()

		viewShowResult.setNeedsDisplay()
		viewShowResult.hidden = false
		viewShowResult.show()
	}

	func hideViewResult() {
		/*leadingConstraintViewShowResult.constant = -widthViewResult
		 UIView.animateWithDuration(timeAnimationHideView, delay: 0.0, options: .CurveEaseOut,
		 animations: {
		 self.view.layoutIfNeeded()
		 self.viewShowResult.alpha = 0.0
		 }, completion: { _ in
		 self.leadingConstraintViewShowResult.constant = 0
		 self.bottomConstraintViewShowResult.constant = -self.heightViewResult
		 self.view.layoutIfNeeded()
		 })*/

		leadingConstraintViewShowResult.constant = -widthViewResult
		self.view.layoutIfNeeded()
		viewShowResult.hide()
	}

	func alphaViewResult(alpha: CGFloat) {
		UIView.animateWithDuration(0.1) {
			self.viewShowResult.alpha = alpha
		}
	}

	func handleTapGestureViewResult(recognizer: UITapGestureRecognizer) {
		switch recognizer.state {
		case .Began:
			alphaViewResult(alphaViewResultWhenSelect)
			break
		case .Ended:
			alphaViewResult(1.0)
			break
		default:
			break
		}
	}

	func handlePanGestureViewResult(recognizer: UIPanGestureRecognizer) {
		switch recognizer.state {
		case .Began:
			alphaViewResult(alphaViewResultWhenSelect)
			break
		case .Ended:
			alphaViewResult(1.0)
			break
		default:
			let translation = recognizer.translationInView(self.view)
			if let _ = recognizer.view {
				let newConstraint = bottomConstraintViewShowResult.constant - translation.y
				let minConstraint: CGFloat = 0
				let maxConstraint: CGFloat = CGRectGetHeight(self.view.frame) - heightViewResult

				if minConstraint...maxConstraint ~= newConstraint {
					bottomConstraintViewShowResult.constant -= translation.y
					view.layoutIfNeeded()
				}
			}
			recognizer.setTranslation(CGPoint.zero, inView: self.view)
			break
		}
	}

	func resignTextView() {
		self.view.endEditing(true)
	}

	func hideAllSubviews() {
		buttonCheck.hidden = true
		buttonClose.hidden = true
		progressView.hidden = true
		currentViewQuestion?.hidden = true
		viewShowResult.hidden = true
	}

	func showAllSubviews() {
		buttonCheck.hidden = false
		buttonClose.hidden = false
		progressView.hidden = false
		currentViewQuestion?.hidden = false
	}

	// MARK: - Loading
	func showLoadingIndicator() {
//		let size = CGSize(width: 100, height: 100)
//		startActivityAnimating(size, message: nil, type: NVActivityIndicatorType.BallPulse)
		indicator.startAnimation()
	}

	func hideLoadingIndicator() {
//		stopActivityAnimating()
		indicator.stopAnimation()
	}

	// MARK: - Question View Methods
	func viewQuestionWithQuesion(question: Question) -> ViewQuestion {
		var viewQuestion: ViewQuestion!

		switch question.type {
		case .OneChoose:
			viewQuestion = ViewQuestionOneChoose.instanceFromNib()
		case .MultiChoose:
			viewQuestion = ViewQuestionMultiChoose.instanceFromNib()
		case .TextAnswer:
			viewQuestion = ViewQuestionTextAnswer.instanceFromNib()
		case .Puzzle:
			viewQuestion = ViewQuestionPuzzle.instanceFromNib()
		case .Photo:
			viewQuestion = ViewQuestionPhoto.instanceFromNib()
		}

		viewQuestion.question = question
		viewQuestion.delegate = self

		return viewQuestion
	}

	func showViewQuestion(viewQuestion: ViewQuestion) {
		viewQuestion.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(viewQuestion)
		self.view.bringSubviewToFront(viewShowResult)

		let views = ["view": self.view, "viewQuestion": viewQuestion, "buttonCheck": buttonCheck]
		var allConstraints = [NSLayoutConstraint]()
		let horizontallConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
			"H:|-0-[viewQuestion]-0-|",
			options: [],
			metrics: nil,
			views: views)
		allConstraints += horizontallConstraints

		let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
			"V:|-40-[viewQuestion]-15-[buttonCheck]",
			options: [],
			metrics: nil,
			views: views)
		allConstraints += verticalConstraints

		NSLayoutConstraint.activateConstraints(allConstraints)
	}

	func hideQuestionView(questionView: ViewQuestion?) {
		if let questionView = questionView {
			questionView.translatesAutoresizingMaskIntoConstraints = true

			questionView.alpha = 0.5
			UIView.animateWithDuration(Constants.timeAnimationHideView, delay: 0.0, options: .CurveEaseOut,
				animations: {
//					questionView.frame.origin.x = -questionView.frame.size.width
					questionView.alpha = 0.0
				}, completion: { _ in
					questionView.removeFromSuperview()
			})
		}
	}

	override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
		let view = anim.valueForKey("view")
		view?.removeFromSuperview()
	}

	// MARK: - Notification Methods
	func handleKeyboardWillShow(notification: NSNotification) {
		updateBottomLayoutConstraintWithNotification(notification)
	}

	func handleKeyboardWillHide(notification: NSNotification) {
		updateBottomLayoutConstraintWithNotification(notification)
	}

	func updateBottomLayoutConstraintWithNotification(notification: NSNotification) {
		let userInfo = notification.userInfo!

		let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
		let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
		let convertedKeyboardEndFrame = view.convertRect(keyboardEndFrame, fromView: view.window)
		let rawAnimationCurve = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).unsignedIntValue << 16
		let animationCurve = UIViewAnimationOptions(rawValue: UInt(rawAnimationCurve))

		if notification.name == UIKeyboardWillHideNotification {
			bottomConstraintButtonCheck.constant = 15
		} else {
			bottomConstraintButtonCheck.constant = CGRectGetMaxY(view.bounds) - convertedKeyboardEndFrame.minY + 15
		}

		UIView.animateWithDuration(animationDuration, delay: 0.0, options: animationCurve, animations: {
			self.view.layoutIfNeeded()
			}, completion: nil)
	}

	// MARK: - Actions
	@IBAction func close(sender: AnyObject) {
		let title = NSLocalizedString("Are you sure want to close?", comment: "")
		let message = NSLocalizedString("The question you anwsered will be lost.", comment: "")
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)

		let actionClose = UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .Default) { (_) in
			self.hideAllSubviews()
			self.dismissViewControllerAnimated(true) {

			}
		}
		let actionCancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel) { (_) in

		}

		alertController.addAction(actionClose)
		alertController.addAction(actionCancel)

		self.presentViewController(alertController, animated: true) {

		}
	}

	@IBAction func checkAnswer(sender: AnyObject) {
		if !isAnswered { // show result
			isAnswered = true
			layoutAfterAnswerQuestion()
			currentViewQuestion?.userInteractionEnabled = false

			if let question = currentViewQuestion?.question {
				let result = question.checkResult()
				showViewResultWithResult(result)
			}

			progressView.progress = Float(indexQuestion + 1) / Float(dataHelper.exam.questionList.count)
		} else { // next question
			indexQuestion += 1
			disableButtonCheck()

			if indexQuestion < dataHelper.exam.questionList.count {
				isAnswered = false
				layoutBeforeAnswerQuestion()
				hideViewResult()
				hideQuestionView(currentViewQuestion)

				let question = dataHelper.exam.questionList[indexQuestion]
				currentViewQuestion = viewQuestionWithQuesion(question)
				currentViewQuestion?.userInteractionEnabled = true
				showViewQuestion(currentViewQuestion!)
				currentViewQuestion?.show()
			} else {
				currentViewQuestion?.removeFromSuperview()
				currentViewQuestion = nil
				self.performSegueWithIdentifier("showResultSegure", sender: nil)
			}
		}
	}
}

// MARK: - UIGestureRecognizerDelegate
extension AnswerViewController: UIGestureRecognizerDelegate {
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}

	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
		if let _ = touch.view as? UIButton {
			return false
		}
		if let _ = touch.view as? UITextView {
			return false
		}
		return true
	}
}

// MARK: - ViewResultDelegate
extension AnswerViewController: ViewResultDelegate {
	func viewResultNeedReport(viewResult: ViewResult) {
		let reportText = NSLocalizedString("Report question.", comment: "")
		let actionReport = UIAlertAction(title: reportText, style: .Default) { (_) in

		}
		let cancelText = NSLocalizedString("Cancel", comment: "")
		let actionCancel = UIAlertAction(title: cancelText, style: .Cancel) { (_) in

		}

		let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
		actionSheet.addAction(actionReport)
		actionSheet.addAction(actionCancel)

		if let popoverController = actionSheet.popoverPresentationController {
			popoverController.sourceView = self.view
			popoverController.sourceRect = self.view.bounds
			popoverController.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
		}

		self.presentViewController(actionSheet, animated: true, completion: nil)
	}
}

// MARK: - ViewQuestionDelegate
extension AnswerViewController: ViewQuestionDelegate {
	func viewQuestion(viewQuestion: ViewQuestion, didSelectAnswer answer: Answer) {
		dataHelper.exam = (answer.isSelected == false) ? dataHelper.selectAnswer(answer, ofQuestion: viewQuestion.question, ofExam: dataHelper.exam) : dataHelper.unSelectAnswer(answer, ofQuestion: viewQuestion.question, ofExam: dataHelper.exam)

		let question = dataHelper.exam.questionList[indexQuestion]
		currentViewQuestion?.question = question

		if question.isUserChooseAnswer() {
			activeButtonCheck()
		} else {
			disableButtonCheck()
		}
	}

	func viewQuestion(viewQuestion: ViewQuestion, didAssignAnswer answer: Answer, toIndex index: Int?) {
		if let index = index {
			dataHelper.exam = dataHelper.assingAnswer(answer, ofQuestion: viewQuestion.question, ofExam: dataHelper.exam, toIndex: index)
		} else {
			dataHelper.exam = dataHelper.unassingAnswer(answer, ofQuestion: viewQuestion.question, ofExam: dataHelper.exam)
		}

		let question = dataHelper.exam.questionList[indexQuestion]
		currentViewQuestion?.question = question

		if question.isUserChooseAnswer() {
			activeButtonCheck()
		} else {
			disableButtonCheck()
		}
	}

	func viewQuestion(viewQuestion: ViewQuestion, didTypeText text: String) {
		if text.length == 0 {
			disableButtonCheck()
		} else {
			activeButtonCheck()
		}
	}
}
