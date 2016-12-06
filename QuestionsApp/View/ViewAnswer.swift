//
//  ViewAnswer.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 6/8/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit
import SpeedLog
import iosMath

@objc protocol ViewAnswerDelegate {
	func viewAnswerDidSelect(view: ViewAnswer)
}

class ViewAnswer: UIView {

	let borderWidth: CGFloat = 0.5

	@IBOutlet weak var buttonChooseAnswer: MultiLineButton!
    
    var label: MTMathUILabel! = {
        let label = MTMathUILabel()
        label.paddingLeft = 45.0
        label.labelMode = MTMathUILabelMode.Display
        label.font = MTFontManager().latinModernFontWithSize(18.0)
//        label.font = MTFontManager().fontWithName("Helvetica", size: 18.0)
        label.userInteractionEnabled = false
        return label
    }()
    
    var radioSelectedImage = "radio-selected"
    var radioUnselectedImage = "radio-unselected"

	var answer: Answer! {
		didSet {
			buttonChooseAnswer.setTitle(answer.text, forState: .Normal)
            
            label.latex = String(format: "\text {%@}", answer.text)
		}
	}

	weak var delegate: ViewAnswerDelegate?

	class func instanceFromNib() -> ViewAnswer {
		return UINib(nibName: "ViewAnswer", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! ViewAnswer
	}

	override func awakeFromNib() {
		super.awakeFromNib()

		buttonChooseAnswer.setTitleColor(Constants.Color.colorTitleButtonChooseAnswer, forState: .Normal)
        buttonChooseAnswer.setTitleColor(UIColor.clearColor(), forState: .Normal)

		self.backgroundColor = UIColor.whiteColor()
//		buttonChooseAnswer.backgroundColor = UIColor.whiteColor()
        
        self.addSubview(label)
        
//        let views = ["label": label]
//        var allConstraints = [NSLayoutConstraint]()
//        let horizontallConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
//            String(format: "H:|[label]|"),
//            options: [],
//            metrics: nil,
//            views: views)
//        allConstraints += horizontallConstraints
//        
//        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
//            String(format: "V:|[label]|"),
//            options: [],
//            metrics: nil,
//            views: views)
//        allConstraints += verticalConstraints
//        
//        NSLayoutConstraint.activateConstraints(allConstraints)
        
        label.frame = self.bounds
	}

    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = self.bounds
    }
    
	deinit {
		SpeedLog.print("VIEW ANSWER DEALLOC")
	}

	// Only override drawRect: if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	override func drawRect(rect: CGRect) {
		// Drawing code
		self.layer.cornerRadius = 3.0
		self.layer.masksToBounds = true
		self.layer.borderColor = Constants.Color.colorBorderButtonChooseAnswer.CGColor
		self.layer.borderWidth = borderWidth

		reset()
	}

	// MARK: - Public methods
	func reset() {
		if answer.isSelected {
			buttonChooseAnswer.backgroundColor = Constants.Color.colorSelectedButtonChooseAnswer
			buttonChooseAnswer.setImage(UIImage(named: radioSelectedImage), forState: .Normal)
			self.layer.borderWidth = 0.0
		} else {
			buttonChooseAnswer.backgroundColor = UIColor.clearColor()
			buttonChooseAnswer.setImage(UIImage(named: radioUnselectedImage), forState: .Normal)
			self.layer.borderWidth = borderWidth
		}
	}

	// MARK: - Private methods
	private func didSelectAnswer() {
		delegate?.viewAnswerDidSelect(self)
	}

	// MARK: - Action
	@IBAction func handleButtonTouchUp(sender: AnyObject) {
		buttonChooseAnswer.backgroundColor = Constants.Color.colorSelectedButtonChooseAnswer
		buttonChooseAnswer.setImage(UIImage(named: radioSelectedImage), forState: .Normal)
		self.layer.borderWidth = 0.0

		didSelectAnswer()
	}

	@IBAction func handleButtonTouchDown(sender: AnyObject) {
		buttonChooseAnswer.backgroundColor = Constants.Color.colorHighlightButtonChooseAnswer
        buttonChooseAnswer.setImage(UIImage(named: radioSelectedImage), forState: .Normal)
		self.layer.borderWidth = 0.0
	}
}

// MARK: - MultiLineButton
class MultiLineButton: UIButton {
    
    // MARK: - Init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    private func commonInit() {
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.lineBreakMode = .ByWordWrapping
    }
    
    // MARK: - Overrides
    
    override func intrinsicContentSize() -> CGSize {
        let size = titleLabel?.intrinsicContentSize() ?? CGSizeZero
        return CGSize(width: size.width, height: size.height + 15)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.preferredMaxLayoutWidth = titleLabel?.frame.size.width ?? 0
        super.layoutSubviews()
    }
    
}
