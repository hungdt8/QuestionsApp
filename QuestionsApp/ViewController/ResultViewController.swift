//
//  ResultViewController.swift
//  QuestionsApp
//
//  Created by Hung Le Duc on 6/7/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit

class ResultViewController: ParentViewController {

	@IBOutlet weak var titleResultTextLabel: UILabel!
	@IBOutlet weak var resultLabel: UILabel!
	@IBOutlet weak var bottomButton: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		bottomButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		bottomButton.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
		bottomButton.layer.cornerRadius = 25.0
		bottomButton.layer.masksToBounds = true
		bottomButton.backgroundColor = Constants.Color.colorActiveButtonCheck
		bottomButton.setTitle(NSLocalizedString("Next", comment: ""), forState: .Normal)

		titleResultTextLabel.text = NSLocalizedString("Result", comment: "")

		let numberCorrectQuestion = dataHelper.exam.questionList.filter({ $0.checkResult() == Result.Right }).count
		let numberQuestion = dataHelper.exam.questionList.count
		let text = NSLocalizedString("You answered correctly: ", comment: "")
		let string = "\(numberCorrectQuestion)" + "/" + "\(numberQuestion)"

		let attributedText = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(17)])
		let attributedString = NSMutableAttributedString(string: string, attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(20)])
		attributedText.appendAttributedString(attributedString)
		resultLabel.attributedText = attributedText
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	/*
	 // MARK: - Navigation

	 // In a storyboard-based application, you will often want to do a little preparation before navigation
	 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	 // Get the new view controller using segue.destinationViewController.
	 // Pass the selected object to the new view controller.
	 }
	 */

	@IBAction func handleBottomButtonTouchUp(sender: AnyObject) {
		bottomButton.hidden = true
		resultLabel.hidden = true
		titleResultTextLabel.hidden = true

		self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: {

		})
	}
}
