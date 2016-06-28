//
//  ParentViewController.swift
//  QuestionsApp
//
//  Created by Hungld on 5/29/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {

	var dataHelper: DataHelper!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let destinationViewController = segue.destinationViewController as? ParentViewController {
			destinationViewController.dataHelper = dataHelper
		}
	}

	/*
	 // MARK: - Navigation

	 // In a storyboard-based application, you will often want to do a little preparation before navigation
	 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	 // Get the new view controller using segue.destinationViewController.
	 // Pass the selected object to the new view controller.
	 }
	 */

}
