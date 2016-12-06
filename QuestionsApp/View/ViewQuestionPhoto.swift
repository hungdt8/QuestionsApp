//
//  ViewQuestionPhoto.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 6/7/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit
import SpeedLog
import Nuke

class ViewQuestionPhoto: ViewQuestion {
	var photoView: UIImageView!
	let photoHeight = 100
	let photoWidth = 100

	override var question: Question! {
		didSet {
			if let photo = question.photo {
                if let url = NSURL(string: photo) {
                    photoView.nk_setImageWith(url)
                }
			}
		}
	}

	class func instanceFromNib() -> ViewQuestionPhoto {
		return UINib(nibName: "ViewQuestionPhoto", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! ViewQuestionPhoto
	}

	override func awakeFromNib() {
		super.awakeFromNib()
        
		createPhotoView()
	}

	deinit {
		SpeedLog.print("ViewQuestionPhoto Dealloc")
	}

	/*
	 // Only override drawRect: if you perform custom drawing.
	 // An empty implementation adversely affects performance during animation.
	 override func drawRect(rect: CGRect) {
	 // Drawing code
	 }
	 */

	func createPhotoView() {
		photoView = UIImageView(frame: CGRect.zero)
		photoView.translatesAutoresizingMaskIntoConstraints = false
		photoView.contentMode = .ScaleAspectFill
		photoView.clipsToBounds = true
		self.addSubview(photoView)
        
        photoView.image = UIImage(named: "place-holder-large")

		let views = ["photoView": photoView, "labelQuestion": labelQuestion, "view": self]
		var allConstraints = [NSLayoutConstraint]()
		let horizontallConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
			String(format: "H:[photoView(%d)]", photoWidth),
			options: [NSLayoutFormatOptions.AlignAllCenterY],
			metrics: nil,
			views: views)
		allConstraints += horizontallConstraints

		let centerX = NSLayoutConstraint(item: photoView,
			attribute: .CenterX,
			relatedBy: .Equal,
			toItem: self,
			attribute: .CenterX,
			multiplier: 1.0,
			constant: 0.0)
		allConstraints.append(centerX)

		let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
			String(format: "V:[labelQuestion]-%d-[photoView(%d)]", 5, photoHeight),
			options: [],
			metrics: nil,
			views: views)
		allConstraints += verticalConstraints

		NSLayoutConstraint.activateConstraints(allConstraints)
	}

	override func createAnswerViews() {
		removeOldViewAnswers()

		topConstraintTheFirstViewAnswer = photoHeight + 20
		generateAnswerViews()
	}
}
