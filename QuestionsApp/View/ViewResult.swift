//
//  ViewResult.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 6/4/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit
import SpeedLog
import Spring

@objc protocol ViewResultDelegate {
	func viewResultNeedReport(viewResult: ViewResult)
}

class ViewResult: SpringView {

	@IBOutlet weak var labelNotifyResult: UILabel!
	@IBOutlet weak var labelCorrectAnwser: UILabel!
	@IBOutlet weak var buttonReport: UIButton!

	@IBOutlet weak var topLabelNotifyConstraint: NSLayoutConstraint!

	weak var delegate: ViewResultDelegate?

	var colorNotifyPart: UIColor! = Constants.Color.colorNotifyPartRight
	var colorReportPart: UIColor! = Constants.Color.colorReportPartRight

	var rightAnswer: String!

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	// Only override drawRect: if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	override func drawRect(rect: CGRect) {
		super.drawRect(rect)

		let context = UIGraphicsGetCurrentContext()
		CGContextSaveGState(context!)

		CGContextSetStrokeColorWithColor(context!, colorNotifyPart.CGColor)
		CGContextSetLineWidth(context!, 1)
		CGContextMoveToPoint(context!, 0, 0)
		CGContextAddLineToPoint(context!, self.frame.size.width - 15, 0)
		CGContextAddLineToPoint(context!, self.frame.size.width - 45, self.frame.size.height / 2)
		CGContextAddLineToPoint(context!, self.frame.size.width - 15, self.frame.size.height)
		CGContextAddLineToPoint(context!, 0, self.frame.size.height)
		CGContextAddLineToPoint(context!, 0, 0)
		CGContextSetFillColorWithColor(context!, colorNotifyPart.CGColor)
		CGContextFillPath(context!)

//		CGContextSetStrokeColorWithColor(context, colorReportPart.CGColor)
//		CGContextSetLineWidth(context, 1)
//		CGContextMoveToPoint(context, 0, self.frame.size.height - 37)
//		CGContextAddLineToPoint(context, self.frame.size.width - 30, self.frame.size.height - 37)
//		CGContextAddLineToPoint(context, self.frame.size.width - 20, self.frame.size.height)
//		CGContextAddLineToPoint(context, 0, self.frame.size.height)
//		CGContextAddLineToPoint(context, 0, self.frame.size.height - 37)
//		CGContextSetFillColorWithColor(context, colorReportPart.CGColor)
//		CGContextFillPath(context)

		self.layer.shadowColor = UIColor.blackColor().CGColor
		self.layer.shadowOpacity = 0.5
		self.layer.shadowOffset = CGSize(width: 0, height: 3)
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		self.backgroundColor = UIColor.clearColor()

		buttonReport.userInteractionEnabled = false

//		layoutRightState()
//		layoutWrongState()
	}

	// MARK: - Public Methods
	func layoutRightState() {
		topLabelNotifyConstraint.constant = 30

		colorNotifyPart = Constants.Color.colorNotifyPartRight
		colorReportPart = Constants.Color.colorReportPartRight

		buttonReport.setImage(UIImage(named: "report-green"), forState: .Normal)

		labelNotifyResult.textColor = Constants.Color.colorTextNotifyRigh
		labelNotifyResult.text = NSLocalizedString("Correct", comment: "")
		labelCorrectAnwser.hidden = true
	}

	func layoutWrongState() {
		topLabelNotifyConstraint.constant = 5

		colorNotifyPart = Constants.Color.colorNotifyPartWrong
		colorReportPart = Constants.Color.colorReportPartWrong

		buttonReport.setImage(UIImage(named: "report-red"), forState: .Normal)

		labelNotifyResult.textColor = Constants.Color.colorTextNotifyWrong
		labelNotifyResult.text = NSLocalizedString("Incorrect", comment: "")

		labelCorrectAnwser.hidden = false
		labelCorrectAnwser.text = NSLocalizedString("Correct answer: ", comment: "") + rightAnswer
	}

	func show() {
		self.hidden = false
		self.animation = "fadeInUp"
		self.curve = "easeIn"
		self.duration = 0.2
		self.damping = 1.0
		self.animate()
	}

	func hide() {
		self.alpha = 1.0
		UIView.animateWithDuration(Constants.timeAnimationHideView, delay: 0.0, options: .CurveEaseOut,
			animations: {
				self.alpha = 0.0
			}, completion: { _ in

		})

//		self.hidden = false
//		self.animation = "fadeInLeft"
//		self.curve = "easeOut"
//		self.duration = 0.1
//		self.damping = 1.0
//		self.animate()
	}

	// MARK: - Actions
//	@IBAction func handleReportButtonTapped(sender: AnyObject) {
//		delegate?.viewResultNeedReport(self)
//	}

}
