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
	let answerViewHeight = 38
	let answerViewsGap = 8

    var labelOrder: UILabel! = {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = Constants.Color.colorQuestionLabel
        label.font = Constants.Font.fontOrderLabel
        return label
    }()
    
    var questionTextView: MathTextView?

	var question: Question! {
		didSet {
            labelOrder.text = question.questionTypeText
            
            if questionTextView == nil {
                let questionText = String(format: "%@", question.question)
                questionTextView = MathTextView(text: questionText, color: Constants.Color.colorQuestionLabel, font: Constants.Font.fontQuestionLabel)
                questionTextView?.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(questionTextView!)
                
                let views = ["view": self, "questionTextView": questionTextView!]
                var allConstraints = [NSLayoutConstraint]()
                let horizontallConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
                    "H:|-20-[questionTextView]-20-|",
                    options: [],
                    metrics: nil,
                    views: views)
                allConstraints += horizontallConstraints
                
                let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
                    "V:|-35-[questionTextView]",
                    options: [],
                    metrics: nil,
                    views: views)
                allConstraints += verticalConstraints
                
                NSLayoutConstraint.activateConstraints(allConstraints)
            }
            
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

		createOrderLabel()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
	}

	func createOrderLabel() {
		self.addSubview(labelOrder)

		let views = ["view": self, "labelOrder": labelOrder]
		var allConstraints = [NSLayoutConstraint]()
		let horizontallConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
			"H:|-20-[labelOrder]-20-|",
			options: [],
			metrics: nil,
			views: views)
		allConstraints += horizontallConstraints

		let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
			"V:|-0-[labelOrder(30)]",
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
        var aboveView: UIView! = questionTextView
        
		for (index, answer) in question.answerList!.enumerate() {
			let answerView = ViewAnswer.instanceFromNib()
            
            if question.type == QuestionType.MultiChoose {
                answerView.radioSelectedImage = "radio-rectangle-selected"
                answerView.radioUnselectedImage = "radio-rectangle-unselected"
            } else {
                answerView.radioSelectedImage = "radio-selected"
                answerView.radioUnselectedImage = "radio-unselected"
            }
            
			answerView.delegate = self
			answerView.answer = answer
			answerView.tag = tagAnswerView

			answerView.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(answerView)
            
			let views = ["view": self, "answerView": answerView, "aboveView": aboveView]
			var allConstraints = [NSLayoutConstraint]()
			let horizontallConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
				String(format: "H:|-%f-[answerView]-%f-|", Constants.commonGap, Constants.commonGap),
				options: [],
				metrics: nil,
				views: views)
			allConstraints += horizontallConstraints

			let gap = answerViewsGap
            
            var topConstraint: Int = 0
            if index == 0 {
                topConstraint = topConstraintTheFirstViewAnswer
            } else {
                topConstraint = gap
            }
            
            var str: String!
            if index == question.answerList!.count - 1 {
                str = String(format: "V:[aboveView]-%d-[answerView]-10-|", topConstraint)
            } else {
                str = String(format: "V:[aboveView]-%d-[answerView]", topConstraint)
            }
            
			let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
				str,
				options: [],
				metrics: nil,
				views: views)
			allConstraints += verticalConstraints

			NSLayoutConstraint.activateConstraints(allConstraints)
            
            aboveView = answerView
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
