//
//  ViewQuestionPuzzle.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 6/7/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit
import SpeedLog

class ViewQuestionPuzzle: ViewQuestion {

	var isExistAnswerViews = false

	let targetView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.clearColor()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	class func instanceFromNib() -> ViewQuestionPuzzle {
		return UINib(nibName: "ViewQuestionPuzzle", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! ViewQuestionPuzzle
	}

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		for v in self.subviews {
			if let puzzle = v as? PuzzleView {
				let index = puzzle.tag - 1
				let answer = puzzle.answer

				puzzle.frame = (answer.indexSelected == nil) ? frameUnselectedPuzzle(atIndex: index, withAnswer: answer) : frameSelectedPuzzle(atIndex: answer.indexSelected!, withAnswer: answer)
				puzzle.backgroundView.frame = frameUnselectedPuzzle(atIndex: index, withAnswer: answer)
			}
		}
	}

	deinit {
		SpeedLog.print("ViewQuestionPuzzle Dealloc")
	}

	/*
	 // Only override drawRect: if you perform custom drawing.
	 // An empty implementation adversely affects performance during animation.
	 override func drawRect(rect: CGRect) {
	 // Drawing code
	 }
	 */

	func configTargetView() {
		let views = ["view": self, "targetView": targetView, "labelQuestion": labelQuestion]
		var allConstraints = [NSLayoutConstraint]()
		let horizontallConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
			"H:|[targetView]|",
			options: [],
			metrics: nil,
			views: views)
		allConstraints += horizontallConstraints

		let height = 44 * 3
		let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
			String(format: "V:[labelQuestion]-%d-[targetView(%d)]", topConstraintTheFirstViewAnswer, height),
			options: [],
			metrics: nil,
			views: views)
		allConstraints += verticalConstraints

		NSLayoutConstraint.activateConstraints(allConstraints)

		let topAlign: CGFloat = CGFloat(height / 3)
		for i in 0...2 {
			let line = CALayer()
			let x: CGFloat = CGFloat(Constants.commonGap)
			let height: CGFloat = 1.5
			let y = topAlign + 44 * CGFloat(i)
			let width = windowWidth() - (2 * x)

			line.backgroundColor = UIColor.lightGrayColor().CGColor
			line.frame = CGRect(x: x, y: y, width: width, height: height)
			targetView.layer.addSublayer(line)
		}
	}

	func createPuzzleViews() {
		for (index, answer) in question.answerList!.enumerate() {
			let puzzle = PuzzleView(answer: answer)
			puzzle.frame = (answer.indexSelected == nil) ? frameUnselectedPuzzle(atIndex: index, withAnswer: answer) : frameSelectedPuzzle(atIndex: answer.indexSelected!, withAnswer: answer)
			puzzle.delegate = self
			puzzle.tag = index + 1
			addSubview(puzzle.backgroundView)
			addSubview(puzzle)

		}
	}

	override func createAnswerViews() {
		if !isExistAnswerViews {
			isExistAnswerViews = true

			addSubview(targetView)
			configTargetView()

			createPuzzleViews()
		} else {
			for (index, answer) in question.answerList!.enumerate() {
				if let puzzle = self.viewWithTag(index + 1) as? PuzzleView {
					puzzle.answer = answer
				}
			}
		}
	}

	func frameUnselectedPuzzle(atIndex index: Int, withAnswer answer: Answer) -> CGRect {
		let width = 50
		let height = 30
		let gap = 5
		let y = Int(CGRectGetMaxY(targetView.frame) + 50)

		let numberAnswer = question.answerList!.count
		let leftAlign = (Int(windowWidth()) - (numberAnswer * width + (numberAnswer - 1) * gap)) / 2

		return CGRect(x: leftAlign + (width + gap) * index, y: y, width: width, height: height)
	}

	func frameSelectedPuzzle(atIndex index: Int, withAnswer answer: Answer) -> CGRect {
		let width = 50
		let height = 30
		let gap = 5
		let y = Int(CGRectGetMaxY(labelQuestion.frame)) + 44 - height + topConstraintTheFirstViewAnswer - 2

		let leftAlign = Constants.commonGap

		return CGRect(x: leftAlign + (width + gap) * index, y: y, width: width, height: height)
	}
}

// MARK: - PuzzleViewDelegate
extension ViewQuestionPuzzle: PuzzleViewDelegate {
	func puzzleViewDidTapped(puzzleView: PuzzleView) {
//		let index = puzzleView.tag - 1
		let answer = puzzleView.answer
		let numberSelectedAnswer = question.answerList!.filter({ $0.indexSelected != nil }).count

		if let _ = answer.indexSelected { // unAssign index
			delegate?.viewQuestion(self, didAssignAnswer: answer, toIndex: nil)

			UIView.animateWithDuration(0.2, animations: {
//				puzzleView.frame = self.frameUnselectedPuzzle(atIndex: index, withAnswer: answer)

				for (index, answer) in self.question.answerList!.enumerate() {
					if let puzzle = self.viewWithTag(index + 1) as? PuzzleView {
						puzzle.frame = (answer.indexSelected == nil) ? self.frameUnselectedPuzzle(atIndex: index, withAnswer: answer) : self.frameSelectedPuzzle(atIndex: answer.indexSelected!, withAnswer: answer)
					}
				}
			}) { (_) in

			}
		} else { // assing index

			delegate?.viewQuestion(self, didAssignAnswer: answer, toIndex: numberSelectedAnswer)

			UIView.animateWithDuration(0.2, animations: {
				puzzleView.frame = self.frameSelectedPuzzle(atIndex: numberSelectedAnswer, withAnswer: answer)

			}) { (_) in

			}
		}
	}
}
