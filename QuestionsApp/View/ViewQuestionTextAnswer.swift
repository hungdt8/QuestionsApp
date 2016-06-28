//
//  ViewQuestionTextAnswer.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 6/7/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit
import SpeedLog

class ViewQuestionTextAnswer: ViewQuestion {

	var textView: UITextView!

	class func instanceFromNib() -> ViewQuestionTextAnswer {
		return UINib(nibName: "ViewQuestionTextAnswer", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! ViewQuestionTextAnswer
	}

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func drawRect(rect: CGRect) {
		super.drawRect(rect)

	}

	deinit {
		SpeedLog.print("ViewQuestionTextAnswer Dealloc")
	}

	/*
	 // Only override drawRect: if you perform custom drawing.
	 // An empty implementation adversely affects performance during animation.
	 override func drawRect(rect: CGRect) {
	 // Drawing code
	 }
	 */

	// MARK: - Override function
	override func createAnswerViews() {
		if textView != nil {
			textView.removeFromSuperview()
		}

		textView = UITextView(frame: CGRect.zero)
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.clipsToBounds = false
		textView.returnKeyType = .Done
		textView.delegate = self
		self.addSubview(textView)

		let views = ["view": self, "textView": textView, "labelQuestion": labelQuestion]
		var allConstraints = [NSLayoutConstraint]()
		let horizontallConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
			String(format: "H:|-%d-[textView]-%d-|", Constants.commonGap, Constants.commonGap),
			options: [],
			metrics: nil,
			views: views)
		allConstraints += horizontallConstraints

		let str = String(format: "V:[labelQuestion]-%d-[textView]|", topConstraintTheFirstViewAnswer)
		let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
			str,
			options: [],
			metrics: nil,
			views: views)
		allConstraints += verticalConstraints
		NSLayoutConstraint.activateConstraints(allConstraints)

		textView.layer.shadowColor = UIColor.blackColor().CGColor
		textView.layer.shadowOffset = CGSize(width: 1, height: 1)
		textView.layer.shadowOpacity = 0.1
		textView.layer.shadowRadius = 4.0
	}
}

// MARK: -
extension ViewQuestionTextAnswer: UITextViewDelegate {
	func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
		if text == "\n" {
			self.endEditing(true)
		}

		var string = NSString(string: textView.text)
		string = string.stringByReplacingCharactersInRange(range, withString: text)
		SpeedLog.print(string)

		delegate?.viewQuestion(self, didTypeText: string as String)

		return true
	}
}
