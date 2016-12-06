//
//  LinearProgressView.swift
//  LinearProgressBar
//
//  Created by Eliel Gordon on 11/13/15.
//  Copyright © 2015 Eliel Gordon. All rights reserved.
//

import UIKit

protocol LinearProgressDelegate: class {
	func didChangeProgress(fromValue from: Double, toValue to: Double)
}

@IBDesignable
class LinearProgressView: UIView {

	@IBInspectable var barColor: UIColor = UIColor.greenColor()
	@IBInspectable var trackColor: UIColor = UIColor.yellowColor()
	@IBInspectable var barThickness: CGFloat = 10
	@IBInspectable var barPadding: CGFloat = 0
	@IBInspectable var progressValue: CGFloat = 0 {
		didSet {
			if (progressValue >= 100) {
				progressValue = 100
			} else if (progressValue <= 0) {
				progressValue = 0
			}
		}
	}

	weak var delegate: LinearProgressDelegate?

	override func drawRect(rect: CGRect) {
		drawProgressView()
	}

	func drawProgressView() {
		let context = UIGraphicsGetCurrentContext()
		CGContextSaveGState(context!)

		// Progres Bar Track
		CGContextSetStrokeColorWithColor(context!, trackColor.CGColor)
		CGContextBeginPath(context!)
		CGContextSetLineWidth(context!, 2.5)
		CGContextMoveToPoint(context!, barPadding, frame.size.height / 2)
		CGContextAddLineToPoint(context!, frame.size.width - barPadding, frame.size.height / 2)
		CGContextSetLineCap(context!, CGLineCap.Round)
		CGContextStrokePath(context!)

		CGContextSetStrokeColorWithColor(context!, barColor.CGColor)
		CGContextSetLineWidth(context!, barThickness)
		CGContextBeginPath(context!)
		CGContextMoveToPoint(context!, barPadding, frame.size.height / 2)
		CGContextAddLineToPoint(context!, barPadding + calcualtePercentage(), frame.size.height / 2)
		CGContextSetLineCap(context!, CGLineCap.Round)
		CGContextStrokePath(context!)

		if progressValue == 100.0 {
			CGContextSetLineWidth(context!, 2.0)
			CGContextSetStrokeColorWithColor(context!, barColor.CGColor)
			let rectangle = CGRect(x: frame.size.width - (barThickness + 4) - 1, y: (frame.size.height - barThickness - 4) / 2, width: barThickness + 4, height: barThickness + 4)
			CGContextAddEllipseInRect(context!, rectangle)
			CGContextStrokePath(context!)
			CGContextSetFillColorWithColor(context!, barColor.CGColor)
			CGContextFillEllipseInRect(context!, rectangle)
		} else {
			CGContextSetLineWidth(context!, 2.0)
			CGContextSetStrokeColorWithColor(context!, trackColor.CGColor)
			let rectangle = CGRect(x: frame.size.width - barThickness - 1, y: (frame.size.height - barThickness) / 2, width: barThickness, height: barThickness)
			CGContextAddEllipseInRect(context!, rectangle)
			CGContextStrokePath(context!)
			CGContextSetFillColorWithColor(context!, trackColor.CGColor)
			CGContextFillEllipseInRect(context!, rectangle)
		}

		CGContextRestoreGState(context!)
	}

	func calcualtePercentage() -> CGFloat {
		let screenWidth = frame.size.width - (barPadding * 2)
		let progress = ((progressValue / 100) * screenWidth)
		return progress < 0 ? barPadding : progress
	}
}
