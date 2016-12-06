//
//  ExamCell.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 6/2/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit
import Spring
import SpeedLog

class ExamCell: ParentCell {

	@IBOutlet weak var viewContainer: SpringView!
	@IBOutlet weak var labelTtitle: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
        
        labelTtitle.textColor = UIColor(hexString: "1b1b1b")
	}

	/*
	 // Only override drawRect: if you perform custom drawing.
	 // An empty implementation adversely affects performance during animation.
	 override func drawRect(rect: CGRect) {
	 // Drawing code
	 }
	 */

	func animateFlyOut() {
		viewContainer.duration = 2.0
		viewContainer.delay = 0.0
		viewContainer.force = 1.0
//        viewContainer.damping = 0.0
//        viewContainer.velocity = 0.0
//        viewContainer.animation = "fadeOut"
		viewContainer.animation = "zoomOut"
		viewContainer.curve = "easeIn"
		viewContainer.animate()
	}

}
