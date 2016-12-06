//
//  PuzzleView.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 6/20/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit
import SpeedLog

protocol PuzzleViewDelegate: class {
	func puzzleViewDidTapped(puzzleView: PuzzleView)
}

class PuzzleView: UIView {
	var answer: Answer!

	let label: UILabel = {
		let label = UILabel()
		label.textAlignment = .Center
		label.textColor = UIColor.darkGrayColor()
		label.font = Constants.Font.fontAnswerPuzzle

		return label
	}()

	let backgroundView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
		return view
	}()
    
    let button: UIButton = {
       let button = UIButton(type: .Custom)
        return button
    }()

	weak var delegate: PuzzleViewDelegate?

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	init(answer: Answer) {
		super.init(frame: CGRect.zero)
		backgroundColor = UIColor.whiteColor()

		self.answer = answer

		addSubview(label)
		label.text = answer.text
		label.frame = self.bounds
		label.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

		addTapGesture()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
        
        button.frame = self.bounds
	}

	deinit {
		SpeedLog.print("PuzzleView dealloc")
	}

	// MARK: - Method
	func addTapGesture() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PuzzleView.handleTapGesture))
		self.addGestureRecognizer(tapGesture)
	}
    
	func handleTapGesture(gesture: UITapGestureRecognizer) {
		delegate?.puzzleViewDidTapped(self)
	}

	func calculateWidth() -> Double {
		let text = NSString(string: answer.text)
		let width = text.sizeWithAttributes([NSFontAttributeName: Constants.Font.fontAnswerPuzzle]).width
		return Double(width) + 5
	}
}
