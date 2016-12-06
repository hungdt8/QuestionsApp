//
//  ExtentButton.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 11/1/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit

class ExtentButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        let margin: CGFloat = 8.0
        let rect = CGRectInset(self.bounds, -margin, -margin)
        return CGRectContainsPoint(rect, point)
    }
}
