//
//  ViewQuestion.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 6/7/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit
import Spring
import SpeedLog

protocol ViewQuestionDelegate: class {
	func viewQuestion(viewQuestion: ViewQuestion, didSelectAnswer answer: Answer) // choice
	func viewQuestion(viewQuestion: ViewQuestion, didAssignAnswer answer: Answer, toIndex index: Int?) // puzzle
	func viewQuestion(viewQuestion: ViewQuestion, didTypeText text: String) // text
}

@objc(ViewQuestion)
class ViewQuestion: SpringView {
	let tagAnswerView = 1000
	var topConstraintTheFirstViewAnswer: Int! = 15
	let answerViewHeight = 44
	let answerViewsGap = 8

	var labelQuestion: UILabel!

	var question: Question! {
		didSet {
			if question.type == .OneChoose || question.type == .Photo {
				labelQuestion.text = question.question + NSLocalizedString(" ", comment: "") + NSLocalizedString("(Choose a answer)", comment: "")
			} else if question.type == .MultiChoose {
				labelQuestion.text = question.question + NSLocalizedString(" ", comment: "") + NSLocalizedString("(Choose multiple answers)", comment: "")
			} else {
				labelQuestion.text = question.question
			}
			labelQuestion.sizeToFit()

			createAnswerViews()
		}
	}

	weak var delegate: ViewQuestionDelegate?

	/*
	 // Only override drawRect: if you perform custom drawing.
	 // An empty implementation adversely affects performance during animation.
	 override func drawRect(rect: CGRect) {
	 // Drawing code
	 }
	 */
	override func awakeFromNib() {
		super.awakeFromNib()

		self.backgroundColor = UIColor.clearColor()

		createQuestionLabel()

	}

	override func layoutSubviews() {
		super.layoutSubviews()
	}

	func createQuestionLabel() {
		labelQuestion = UILabel(frame: CGRect.zero)
		labelQuestion.translatesAutoresizingMaskIntoConstraints = false
		labelQuestion.numberOfLines = 0
		labelQuestion.textColor = Constants.Color.colorQuestionLabel
		labelQuestion.font = Constants.Font.fontQuestionLabel
		self.addSubview(labelQuestion)

		let views = ["view": self, "labelQuestion": labelQuestion]
		var allConstraints = [NSLayoutConstraint]()
		let horizontallConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
			"H:|-20-[labelQuestion]-20-|",
			options: [],
			metrics: nil,
			views: views)
		allConstraints += horizontallConstraints

		let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
			"V:|-5-[labelQuestion(>=30)]",
			options: [],
			metrics: nil,
			views: views)
		allConstraints += verticalConstraints

		NSLayoutConstraint.activateConstraints(allConstraints)
	}

	func removeOldViewAnswers() {
		for v in self.subviews {
			if v.tag == tagAnswerView {
				v.removeFromSuperview()
			}
		}
	}

	func generateAnswerViews() {
		for (index, answer) in question.answerList!.enumerate() {
			let answerView = ViewAnswer.instanceFromNib()
			answerView.delegate = self
			answerView.answer = answer
			answerView.tag = tagAnswerView

			answerView.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(answerView)

			let views = ["view": self, "answerView": answerView, "labelQuestion": labelQuestion]
			var allConstraints = [NSLayoutConstraint]()
			let horizontallConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
				String(format: "H:|-%d-[answerView]-%d-|", Constants.commonGap, Constants.commonGap),
				options: [],
				metrics: nil,
				views: views)
			allConstraints += horizontallConstraints

			let height = answerViewHeight
			let gap = answerViewsGap
			let str = String(format: "V:[labelQuestion]-%d-[answerView(%d)]", topConstraintTheFirstViewAnswer + (gap + height) * index, height)
			let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
				str,
				options: [],
				metrics: nil,
				views: views)
			allConstraints += verticalConstraints

			NSLayoutConstraint.activateConstraints(allConstraints)
		}
	}

	func show() {
		self.hidden = false
		self.animation = "fadeInLeft"
		self.curve = "easeIn"
		self.duration = CGFloat(Constants.timeAnimationHideView)
		self.damping = 1.0
		self.animate()
	}

	func createAnswerViews() {
		removeOldViewAnswers()

		generateAnswerViews()
	}
}

// MARK: - ViewAnswerDelegate
extension ViewQuestion: ViewAnswerDelegate {
	func viewAnswerDidSelect(view: ViewAnswer) {
		delegate?.viewQuestion(self, didSelectAnswer: view.answer)
	}
}
