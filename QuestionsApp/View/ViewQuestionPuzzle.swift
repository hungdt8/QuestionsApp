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

        var height: CGFloat = 0.0
		for v in self.subviews {
			if let puzzle = v as? PuzzleView {
				let index = puzzle.tag - 1
				let answer = puzzle.answer

				puzzle.frame = (answer.indexSelected == nil) ? frameUnselectedPuzzle(atIndex: index, withAnswer: answer) : frameSelectedPuzzle(atIndex: answer.indexSelected!, withAnswer: answer)
				puzzle.backgroundView.frame = frameUnselectedPuzzle(atIndex: index, withAnswer: answer)
                
                if index == question.answerList!.count - 1 {
                    height = CGRectGetMaxY(puzzle.backgroundView.frame)
                }
			}
		}
        
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: height + 10)
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
		let views = ["view": self, "targetView": targetView, "labelQuestion": questionTextView!]
		var allConstraints = [NSLayoutConstraint]()
		let horizontallConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
			"H:|[targetView]|",
			options: [],
			metrics: nil,
			views: views)
		allConstraints += horizontallConstraints

		let height = 44.0 * 3.0
		let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
			String(format: "V:[labelQuestion]-%d-[targetView(%f)]", topConstraintTheFirstViewAnswer, height),
			options: [],
			metrics: nil,
			views: views)
		allConstraints += verticalConstraints

		NSLayoutConstraint.activateConstraints(allConstraints)

		let topAlign = (height / 3)
		for i in 0...2 {
			let line = CALayer()
			let x = Constants.commonGap
			let height = 1.5
			let y = topAlign + 44.0 * Double(i)
			let width = Double(windowWidth()) - (2 * x)

			line.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.4).CGColor
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
		if index == 0 {
			let x = Constants.commonGap
			let y = Double(CGRectGetMaxY(targetView.frame) + 50.0)
			let width = calculateWidthWithAnswer(answer)
			let height = 30.0
			return CGRect(x: x, y: y, width: width, height: height)
		} else {
			let maxWidthLine = Double(windowWidth()) - 2 * Constants.commonGap
			let frontPuzzleFrame = frameUnselectedPuzzle(atIndex: index - 1, withAnswer: question.answerList![index - 1])
			let expectX = Double(frontPuzzleFrame.maxX) + Constants.puzzleGap
			let expectWidth = calculateWidthWithAnswer(answer)

			if expectX + expectWidth > maxWidthLine { // break line
				let x = Constants.commonGap
				let y = Double(frontPuzzleFrame.maxY) + Constants.commonGap
				let width = expectWidth
				let height = 30.0
				return CGRect(x: x, y: y, width: width, height: height)
			} else {
				let x = expectX
				let y = Double(frontPuzzleFrame.origin.y)
				let width = expectWidth
				let height = 30.0
				return CGRect(x: x, y: Double(y), width: width, height: height)
			}
		}
	}

	func frameSelectedPuzzle(atIndex index: Int, withAnswer answer: Answer) -> CGRect {
		if index == 0 {
			let x = Constants.commonGap
			let y = Double(CGRectGetMaxY(questionTextView!.frame)) + 44.0 - 30.0 + Double(topConstraintTheFirstViewAnswer) - 2.0
			let width = calculateWidthWithAnswer(answer)
			let height = 30.0
			return CGRect(x: x, y: y, width: width, height: height)
		} else {
			let maxWidthLine = Double(windowWidth()) - 2 * Constants.commonGap
			let frontPuzzleFrame = frameSelectedPuzzle(atIndex: index - 1, withAnswer: question.getOrderSelectedAnsers()[index - 1])
			let expectX = Double(frontPuzzleFrame.maxX) + Constants.puzzleGap
			let expectWidth = calculateWidthWithAnswer(answer)

			if expectX + expectWidth > maxWidthLine { // break line
				let x = Constants.commonGap
				let y = Double(frontPuzzleFrame.maxY) + Constants.commonGap
				let width = expectWidth
				let height = 30.0
				return CGRect(x: x, y: y, width: width, height: height)
			} else {
				let x = expectX
				let y = Double(frontPuzzleFrame.origin.y)
				let width = expectWidth
				let height = 30.0
				return CGRect(x: x, y: Double(y), width: width, height: height)
			}
		}
	}

	func calculateWidthWithAnswer(answer: Answer) -> Double {
		let text = NSString(string: answer.text)
		let width = text.sizeWithAttributes([NSFontAttributeName: Constants.Font.fontAnswerPuzzle]).width
		return Double(width) + 20
	}

	func calculateXUnselectedPuzzleAtIndex(index: Int) -> Double {
		var x = Constants.commonGap
		for i in 0..<index {
			if let answerList = question.answerList {
				let answer = answerList[i]
				let width = calculateWidthWithAnswer(answer)
				x = x + width + Constants.puzzleGap
			}
		}
		return x
	}
}

// MARK: - PuzzleViewDelegate
extension ViewQuestionPuzzle: PuzzleViewDelegate {
	func puzzleViewDidTapped(puzzleView: PuzzleView) {
		let answer = puzzleView.answer
		let numberSelectedAnswer = question.answerList!.filter({ $0.indexSelected != nil }).count

		if let _ = answer.indexSelected { // unAssign index
			delegate?.viewQuestion(self, didAssignAnswer: answer, toIndex: nil)
                
			UIView.animateWithDuration(0.2, animations: {
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
