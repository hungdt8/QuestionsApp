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
import MessageUI
import GoogleMobileAds

class AnswerViewController: ParentViewController, NVActivityIndicatorViewable, MFMailComposeViewControllerDelegate, GAProtocol {

	@IBOutlet weak var buttonCheck: ExtentButton!
	@IBOutlet weak var buttonClose: ExtentButton!
    @IBOutlet weak var randomButton: ExtentButton!
	@IBOutlet weak var sendFriendButton: UIButton!
	@IBOutlet weak var viewShowResult: ViewResult!
	@IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
	@IBOutlet weak var bottomConstraintViewShowResult: NSLayoutConstraint!
	@IBOutlet weak var leadingConstraintViewShowResult: NSLayoutConstraint!
	@IBOutlet weak var heightConstraintViewShowResult: NSLayoutConstraint!
	@IBOutlet weak var bottomConstraintButtonCheck: NSLayoutConstraint!
    @IBOutlet weak var bannerAD: GADBannerView!
    
	let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: NVActivityIndicatorType.BallPulse)

	var currentViewQuestion: ViewQuestion?

	let alphaViewResultWhenSelect: CGFloat = 0.5
	let defaultBottomConstraintViewResult: CGFloat = 115.0

	var heightViewResult: CGFloat! = windowHeight()
	var widthViewResult: CGFloat! = windowWidth()

	var isAnswered = false
	var indexQuestion = 0

//	@IBOutlet weak var progressView1: LinearProgressView!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		view.backgroundColor = Constants.Color.colorBackgroundQuestionView

		buttonCheck.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		buttonCheck.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18)
		buttonCheck.layer.cornerRadius = 3.0
		buttonCheck.layer.masksToBounds = true

		buttonClose.imageView?.image = buttonClose.imageView?.image?.imageWithRenderingMode(.AlwaysTemplate)
		buttonClose.imageView?.tintColor = UIColor(hex: "6a6a6a")

		sendFriendButton.backgroundColor = UIColor(hex: "68d705")
		sendFriendButton.layer.cornerRadius = 3.0
		sendFriendButton.layer.masksToBounds = true
        
//        scrollView.canCancelContentTouches = true
        scrollView.backgroundColor = UIColor.clearColor()

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
        
        configAdmobBanner()

        if dataHelper.exam.questionList.isEmpty {
            hideAllSubviews()
            showLoadingIndicator()
            getExamDetail()
        } else {
            self.showAllSubviews()
            self.hideLoadingIndicator()
            
            for (index,question) in dataHelper.exam.questionList.enumerate() {
                if question.isUserChooseAnswer() == false {
                    indexQuestion = index
                    break
                }
            }
            showQuestionAtIndex(indexQuestion)
            progressView.progress = dataHelper.exam.getProgress()
            
            if !dataHelper.exam.isRandom {
                randomButton.setImage(UIImage(named: "disable-random"), forState: .Normal)
            } else {
                randomButton.setImage(UIImage(named: "enable-random"), forState: .Normal)
            }
        }
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)

		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AnswerViewController.handleKeyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AnswerViewController.handleKeyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        sendScreenNameGA("Question Screen")
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)

		UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
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
				let minConstraint: CGFloat = 50
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
		sendFriendButton.hidden = true
		progressView.hidden = true
		currentViewQuestion?.hidden = true
		viewShowResult.hidden = true
        randomButton.hidden = true
        bannerAD.hidden = true
	}

	func showAllSubviews() {
		buttonCheck.hidden = false
		buttonClose.hidden = false
		sendFriendButton.hidden = false
		progressView.hidden = false
		currentViewQuestion?.hidden = false
        randomButton.hidden = false
        bannerAD.hidden = false
        
        self.view.bringSubviewToFront(bannerAD)
	}
    
    func isFinish() -> Bool {
        return dataHelper.exam.questionList.filter({$0.isUserChooseAnswer() == true}).count == dataHelper.exam.questionList.count
    }

    func reloadQuestionDataAtIndex(index: Int) {
        let question = dataHelper.exam.questionList[index]
        currentViewQuestion?.question = question
        
        if question.isUserChooseAnswer() {
            activeButtonCheck()
        } else {
            disableButtonCheck()
        }
    }
    
	// MARK: - Loading
	override func showLoadingIndicator() {
//		let size = CGSize(width: 100, height: 100)
//		startActivityAnimating(size, message: nil, type: NVActivityIndicatorType.BallPulse)
		indicator.startAnimation()
	}

	override func hideLoadingIndicator() {
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

    func showQuestionAtIndex(index: Int) {
        let question = dataHelper.exam.questionList[index]
        currentViewQuestion = viewQuestionWithQuesion(question)
        showViewQuestion(currentViewQuestion!)
        
        if question.isEmptyAnswerList() {
            activeButtonCheck()
        }
    }
    
	func showViewQuestion(viewQuestion: ViewQuestion) {
//        return
        
        viewQuestion.userInteractionEnabled = true
        contentView.addSubview(viewQuestion)
        
        if viewQuestion.question.type == QuestionType.Puzzle {
            contentView.translatesAutoresizingMaskIntoConstraints = true
            contentView.frame = scrollView.bounds
        } else {
            contentView.translatesAutoresizingMaskIntoConstraints = false
            viewQuestion.translatesAutoresizingMaskIntoConstraints = false
            
            let views = ["view": contentView, "viewQuestion": viewQuestion, "buttonCheck": buttonCheck]
            var allConstraints = [NSLayoutConstraint]()
            let horizontallConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-0-[viewQuestion]-0-|",
                options: [],
                metrics: nil,
                views: views)
            allConstraints += horizontallConstraints
            
            if viewQuestion.question.type == QuestionType.TextAnswer {
                let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
                    "V:|-0-[viewQuestion]-0-|",
                    options: [],
                    metrics: nil,
                    views: views)
                allConstraints += verticalConstraints
            } else {
                let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
                    "V:|-0-[viewQuestion]-0-|",
                    options: [],
                    metrics: nil,
                    views: views)
                allConstraints += verticalConstraints
            }
            
            NSLayoutConstraint.activateConstraints(allConstraints)
        }
        
        viewQuestion.show()
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

//	override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
//		let view = anim.valueForKey("view")
//		view?.removeFromSuperview()
//	}

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
			bottomConstraintButtonCheck.constant = 65
		} else {
			bottomConstraintButtonCheck.constant = CGRectGetMaxY(view.bounds) - convertedKeyboardEndFrame.minY + 15
		}

		UIView.animateWithDuration(animationDuration, delay: 0.0, options: animationCurve, animations: {
			self.view.layoutIfNeeded()
			}, completion: nil)
	}
    
    // MARK: - API Methods
    func getExamDetail() {
        dataHelper.delegate = self
        dataHelper.getDetailExam(dataHelper.exam)
    }
    
	// MARK: - Actions
	@IBAction func close(sender: AnyObject) {
		let title = NSLocalizedString("Are you sure want to close?", comment: "")
		let message = NSLocalizedString("The question you anwsered will be lost.", comment: "")
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)

		let actionClose = UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .Default) { (_) in
            self.dataHelper.saveExamToDB(self.dataHelper.exam)
            
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

			progressView.progress = dataHelper.exam.getProgress()
		} else { // next
			disableButtonCheck()

			if isFinish() { // last question
                currentViewQuestion?.removeFromSuperview()
                currentViewQuestion = nil
                
                self.dataHelper.saveExamToDB(self.dataHelper.exam)
                
                self.performSegueWithIdentifier("showResultSegure", sender: nil)
			} else { // next question
                isAnswered = false
                layoutBeforeAnswerQuestion()
                hideViewResult()
                hideQuestionView(currentViewQuestion)
                
                if dataHelper.exam.isRandom {
                    let unAnswerdQuestion = dataHelper.exam.questionList.filter({$0.isUserChooseAnswer() == false})
                    if unAnswerdQuestion.isEmpty == false {
                        let index = Int(arc4random_uniform(UInt32(unAnswerdQuestion.count)))
                        print("***** %d",unAnswerdQuestion.count)
                        print("------ %d",index)
                        let question = unAnswerdQuestion[index]
                        indexQuestion = dataHelper.exam.questionList.indexOf({$0.id == question.id}) ?? indexQuestion + 1
                    } else {
                        indexQuestion += 1
                    }
                } else {
                    indexQuestion += 1
                }
                
                showQuestionAtIndex(indexQuestion)
			}
		}
	}
    
    @IBAction func handleSendFriendTouchUp(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: { 
                
            })
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    @IBAction func handleRandomButtonTouchUp(sender: AnyObject) {
        if dataHelper.exam.isRandom {
            dataHelper.exam.isRandom = false
            randomButton.setImage(UIImage(named: "disable-random"), forState: .Normal)
        } else {
            dataHelper.exam.isRandom = true
            randomButton.setImage(UIImage(named: "enable-random"), forState: .Normal)
        }
    }
    
    // MARK: - Mail
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
//        mailComposerVC.setToRecipients(["someone@somewhere.com"])
//        mailComposerVC.setSubject("Sending you an in-app e-mail...")
//        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let title = NSLocalizedString("Could Not Send Email.", comment: "")
        let message = NSLocalizedString("Your device could not send e-mail.  Please check e-mail configuration and try again.", comment: "")
        let sendMailErrorAlert = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true) { 
            
        }
    }
    
    //  MARK: - Admod
    private func configAdmobBanner() {
        bannerAD.adUnitID = Constants.admodID
        bannerAD.rootViewController = self
        let request = GADRequest()
        bannerAD.loadRequest(request)
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

        reloadQuestionDataAtIndex(indexQuestion)
	}

	func viewQuestion(viewQuestion: ViewQuestion, didAssignAnswer answer: Answer, toIndex index: Int?) {
		if let index = index {// assining
			dataHelper.exam = dataHelper.assingAnswer(answer, ofQuestion: viewQuestion.question, ofExam: dataHelper.exam, toIndex: index)
		} else { // unassining
			dataHelper.exam = dataHelper.unassingAnswer(answer, ofQuestion: viewQuestion.question, ofExam: dataHelper.exam)
		}

        reloadQuestionDataAtIndex(indexQuestion)
	}

	func viewQuestion(viewQuestion: ViewQuestion, didTypeText text: String) {
        dataHelper.exam = dataHelper.updateAnswerText(text, ofQuestion: viewQuestion.question, ofExam: dataHelper.exam)
        
        reloadQuestionDataAtIndex(indexQuestion)
	}
}

// MARK: - DataHelperDelegate
extension AnswerViewController: DataHelperDelegate {
    func getExamDetailSuccess() {
        self.showAllSubviews()
        self.hideLoadingIndicator()
        
        if !dataHelper.exam.questionList.isEmpty {
            showQuestionAtIndex(indexQuestion)
        } else {
            
        }
        
        if !dataHelper.exam.isRandom {
            randomButton.setImage(UIImage(named: "disable-random"), forState: .Normal)
        } else {
            randomButton.setImage(UIImage(named: "enable-random"), forState: .Normal)
        }
    }
    
    func getExamDetailFail(error: NSError?) {
        self.showAllSubviews()
        self.hideLoadingIndicator()
    }
}
