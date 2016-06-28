//
//  ViewQuestionMultiChoose.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 6/7/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit
import SpeedLog

class ViewQuestionMultiChoose: ViewQuestion {

	class func instanceFromNib() -> ViewQuestionMultiChoose {
		return UINib(nibName: "ViewQuestionMultiChoose", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! ViewQuestionMultiChoose
	}

	deinit {
		SpeedLog.print("ViewQuestionMultiChoose Dealloc")
	}

	/*
	 // Only override drawRect: if you perform custom drawing.
	 // An empty implementation adversely affects performance during animation.
	 override func drawRect(rect: CGRect) {
	 // Drawing code
	 }
	 */

}
