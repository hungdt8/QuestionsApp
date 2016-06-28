//
//  ViewAnswer.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 6/8/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit
import SpeedLog

@objc protocol ViewAnswerDelegate {
	func viewAnswerDidSelect(view: ViewAnswer)
}

class ViewAnswer: UIView {

	@IBOutlet weak var buttonChooseAnswer: UIButton!

	var answer: Answer! {
		didSet {
			buttonChooseAnswer.setTitle(answer.text, forState: .Normal)
		}
	}

	weak var delegate: ViewAnswerDelegate?

	class func instanceFromNib() -> ViewAnswer {
		return UINib(nibName: "ViewAnswer", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! ViewAnswer
	}

	override func awakeFromNib() {
		super.awakeFromNib()

		buttonChooseAnswer.layer.cornerRadius = 22.0
		buttonChooseAnswer.layer.masksToBounds = true
		buttonChooseAnswer.layer.borderColor = Constants.Color.colorBorderButtonChooseAnswer.CGColor
		buttonChooseAnswer.layer.borderWidth = 1.5

		self.backgroundColor = UIColor.clearColor()
	}

	deinit {
		SpeedLog.print("VIEW ANSWER DEALLOC")
	}

	// Only override drawRect: if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	override func drawRect(rect: CGRect) {
		// Drawing code
		reset()
	}

	// MARK: - Public methods
	func reset() {
		if answer.isSelected {
			buttonChooseAnswer.backgroundColor = Constants.Color.colorSelectedButtonChooseAnswer
			buttonChooseAnswer.setTitleColor(UIColor.whiteColor(), forState: .Normal)
			buttonChooseAnswer.setImage(UIImage(named: "radio-selected"), forState: .Normal)
			buttonChooseAnswer.layer.borderWidth = 0.0
		} else {
			buttonChooseAnswer.backgroundColor = UIColor.clearColor()
			buttonChooseAnswer.setTitleColor(UIColor(hexString: "3b3b3b"), forState: .Normal)
			buttonChooseAnswer.setImage(UIImage(named: "radio-unselected"), forState: .Normal)
			buttonChooseAnswer.layer.borderWidth = 1.5
		}
	}

	// MARK: - Private methods
	private func didSelectAnswer() {
		delegate?.viewAnswerDidSelect(self)
	}

	// MARK: - Action
	@IBAction func handleButtonTouchUp(sender: AnyObject) {
		buttonChooseAnswer.backgroundColor = Constants.Color.colorSelectedButtonChooseAnswer
		buttonChooseAnswer.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		buttonChooseAnswer.setImage(UIImage(named: "radio-selected"), forState: .Normal)
		buttonChooseAnswer.layer.borderWidth = 0.0

		didSelectAnswer()
	}

	@IBAction func handleButtonTouchDown(sender: AnyObject) {
		buttonChooseAnswer.backgroundColor = Constants.Color.colorHighlightButtonChooseAnswer
		buttonChooseAnswer.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		buttonChooseAnswer.layer.borderWidth = 0.0
	}

}
