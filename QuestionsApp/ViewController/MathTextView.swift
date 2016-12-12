//
//  MathTextView.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 12/8/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit
import iosMath

class MathTextView: UIView {

    let startMathKey = "#quez_startmath"
    let endMathKey = "#quez_endmath"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(text: String, color: UIColor, font: UIFont) {
        super.init(frame: CGRect.zero)
        
        let array = parseString(text)
        var aboveView: UIView! = self
        for (index,item) in array.enumerate() {
            let string = item.string
            let isMath = item.isMath
            
            var label: UIView!
            if isMath {
                let labelText = MTMathUILabel()
                labelText.labelMode = MTMathUILabelMode.Text
                labelText.font = MTFontManager().latinModernFontWithSize(22.0)
                labelText.userInteractionEnabled = false
                labelText.latex = string //"\\left(\\sum_{k=1}^n a_k b_k \\right)^2 \\le \\left(\\sum_{k=1}^n a_k^2\\right)\\left(\\sum_{k=1}^n b_k^2\\right)"
                
                label = labelText
            } else {
                let labelText = UILabel()
                labelText.numberOfLines = 0
                labelText.textColor = color
                labelText.font = font
                labelText.text = string
                
                label = labelText
            }
            
            label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(label)
            
            let views = ["view": label, "aboveView": aboveView]
            var allConstraints = [NSLayoutConstraint]()
            
            var verticalConstraints: [NSLayoutConstraint]!
            if index == 0 {
                if isMath {
                    let size = label.sizeThatFits(CGSize(width: 0, height: 0))
                    verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
                        String(format: "V:|-0-[view(%f)]",size.height + 10.0),
                        options: [],
                        metrics: nil,
                        views: views)
                } else {
                    verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
                        "V:|-0-[view]",
                        options: [],
                        metrics: nil,
                        views: views)
                }
            } else {
                if isMath {
                    let size = label.sizeThatFits(CGSize(width: 0, height: 0))
                    verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
                        String(format: "V:[aboveView]-0-[view(%f)]",size.height + 10.0),
                        options: [],
                        metrics: nil,
                        views: views)
                } else {
                    verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
                        "V:[aboveView]-0-[view]",
                        options: [],
                        metrics: nil,
                        views: views)
                }
            }
            
            allConstraints += verticalConstraints
            
            if index == array.count - 1 {
                var bottomConstraints: [NSLayoutConstraint]!
                if isMath {
                    let size = label.sizeThatFits(CGSize(width: 0, height: 0))
                    bottomConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
                        String(format: "V:[view(%f)]-0-|",size.height + 10.0),
                        options: [],
                        metrics: nil,
                        views: views)
                } else {
                    bottomConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
                        String(format: "V:[view]-0-|"),
                        options: [],
                        metrics: nil,
                        views: views)
                }
                
                allConstraints += bottomConstraints
            }
            
            let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-0-[view]-0-|",
                options: [],
                metrics: nil,
                views: views)
            allConstraints += horizontalConstraints
            
            NSLayoutConstraint.activateConstraints(allConstraints)
            
            aboveView = label
        }
    }
    
    private func parseString(str: String) -> [(string: String, isMath: Bool)] {
        let scanner = NSScanner(string: str)
        
        var array = [(string: String, isMath: Bool)]()
        while !scanner.atEnd {
            var normalText: NSString?
            scanner.scanUpToString(startMathKey, intoString:&normalText)
            if let normalText = normalText {
                let text = normalText.stringByReplacingOccurrencesOfString(endMathKey, withString: "")
                array.append((text ,false))
            }
            
            var mathText: NSString?
            scanner.scanUpToString(endMathKey, intoString:&mathText)
            if let mathText = mathText {
                let text = mathText.stringByReplacingOccurrencesOfString(startMathKey, withString: "")
                array.append((text,true))
            }
        }
        
        return array
    }
}
