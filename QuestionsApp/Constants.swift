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
	static let commonGap = 15

	struct Color {
		static let colorBackgroundQuestionView = UIColor(hex: "f0f0f0")
		static let colorActiveButtonCheck = UIColor(hex: "7bc70b")
		static let colorDisableButtonCheck = UIColor(hex: "dbdbdb")

		static let colorProgsressAnswer = UIColor(hex: "7bc70b")

		static let colorNotifyPartRight = UIColor(hex: "bff295")
		static let colorReportPartRight = UIColor(hex: "b1ec76")
		static let colorButtonReportTextRight = UIColor(hex: "8ed133")
		static let colorTextNotifyRigh = UIColor(hex: "39bb03")

		static let colorNotifyPartWrong = UIColor(hex: "ffbbba")
		static let colorReportPartWrong = UIColor(hex: "f69c9b")
		static let colorButtonReportTextWrong = UIColor(hex: "c73f43")
		static let colorTextNotifyWrong = UIColor(hex: "ba2215")

		static let colorQuestionLabel = UIColor(hex: "5f5f5f")
		static let colorSelectedButtonChooseAnswer = UIColor(hex: "1eadfc")
		static let colorHighlightButtonChooseAnswer = UIColor(hex: "178ac9")
		static let colorBorderButtonChooseAnswer = UIColor(hex: "d6d6d6")
	}

	struct Font {
		static let fontQuestionLabel = UIFont.boldSystemFontOfSize(18.0)
	}
}
