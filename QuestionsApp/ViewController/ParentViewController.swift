//
//  ParentViewController.swift
//  QuestionsApp
//
//  Created by Hungld on 5/29/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit
import MBProgressHUD

class ParentViewController: UIViewController {

	var dataHelper: DataHelper!
    var isLoading = false

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		self.tabBarController?.tabBar.tintColor = UIColor(hex: "68d705")
		self.edgesForExtendedLayout = .None
		self.extendedLayoutIncludesOpaqueBars = true
//		self.automaticallyAdjustsScrollViewInsets = true
//		self.navigationController?.navigationBar.translucent = true
//		self.tabBarController?.tabBar.translucent = true
	}

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        endLoading()
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
    
    //MARK: - Public Method
    func startLoading() {
        isLoading = true
        showLoadingIndicator()
    }
    
    func endLoading() {
        isLoading = false
        hideLoadingIndicator()
    }
    
    func showLoadingIndicator() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let indicator = MBProgressHUD.showHUDAddedTo(appDelegate.window!, animated: true)
        indicator.mode = MBProgressHUDMode.Indeterminate
        indicator.userInteractionEnabled = false
        indicator.label.text = "Loading"
    }
    
    func hideLoadingIndicator() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        MBProgressHUD.hideHUDForView(appDelegate.window!, animated: true)
    }
    
    func showErrorAlert(error: NSError?) {
        let title = NSLocalizedString("Message", comment: "")
        let message = error?.localizedDescription
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let actionOK = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Cancel) { (_) in
            
        }
        
        alertController.addAction(actionOK)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
}
