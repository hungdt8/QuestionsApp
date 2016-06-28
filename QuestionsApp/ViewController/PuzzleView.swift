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
		label.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
		label.textAlignment = .Center
		label.textColor = UIColor.darkGrayColor()
		return label
	}()

	let backgroundView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
		return view
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

		addTapGesture()
	}

	override func layoutSubviews() {
		super.layoutSubviews()

	}

	override func intrinsicContentSize() -> CGSize {
		return CGSize(width: 50, height: 30)
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
}
