//
//  ViewQuestionOneChoose.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 6/7/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit
import SpeedLog

class ViewQuestionOneChoose: ViewQuestion {

	class func instanceFromNib() -> ViewQuestionOneChoose {
		return UINib(nibName: "ViewQuestionOneChoose", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! ViewQuestionOneChoose
	}

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	deinit {
		SpeedLog.print("ViewQuestionOneChoose Dealloc")
	}

	/*
	 // Only override drawRect: if you perform custom drawing.
	 // An empty implementation adversely affects performance during animation.
	 override func drawRect(rect: CGRect) {
	 // Drawing code
	 }
	 */

}
