//
//  Constants.swift
//  MobilePOS
//
//  Created by Hungld on 1/20/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework

struct Constants {
	static let timeAnimationHideView = 0.2
	static let commonGap = 15.0
	static let puzzleGap = 5.0
    
    static let baseUrl = "http://128.199.114.78:80/API/"
    
    static let admodID = "ca-app-pub-9820076886339598/6126335061"

	struct Color {
		static let colorBackgroundQuestionView = UIColor(hex: "f3f3f3")
		static let colorActiveButtonCheck = UIColor(hex: "68d705")
		static let colorDisableButtonCheck = UIColor(hex: "919191")

		static let colorProgsressAnswer = UIColor(hex: "7bc70b")

		static let colorNotifyPartRight = UIColor(hex: "c7edc3")
		static let colorReportPartRight = UIColor(hex: "c7edc3")
		static let colorButtonReportTextRight = UIColor(hex: "8ed133")
		static let colorTextNotifyRigh = UIColor(hex: "68d705")

		static let colorNotifyPartWrong = UIColor(hex: "c7edc3")
		static let colorReportPartWrong = UIColor(hex: "c7edc3")
		static let colorButtonReportTextWrong = UIColor(hex: "1b1b1b")
		static let colorTextNotifyWrong = UIColor(hex: "ff0000")

		static let colorQuestionLabel = UIColor(hex: "1b1b1b")
		static let colorTitleButtonChooseAnswer = UIColor(hex: "3b3b3b")
		static let colorSelectedButtonChooseAnswer = UIColor(hex: "c7edc3")
		static let colorHighlightButtonChooseAnswer = UIColor(hex: "68d705")
		static let colorBorderButtonChooseAnswer = UIColor(hex: "e1e1e1")
	}

	struct Font {
		static let fontQuestionLabel = UIFont.init(name: "HelveticaNeue-Light", size: 16.0)!
		static let fontOrderLabel = UIFont.init(name: "HelveticaNeue-Bold", size: 16.0)
		static let fontAnswerPuzzle = UIFont.systemFontOfSize(17.0)
	}
    
    struct Key {
        static let data = "data"
    }
}
