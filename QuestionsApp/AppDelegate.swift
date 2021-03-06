//
//  AppDelegate.swift
//  QuestionsApp
//
//  Created by Hungld on 5/29/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import UIKit
import MagicalRecord

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.

        MagicalRecord.setupCoreDataStackWithStoreNamed("Questions")
        
//		application.statusBarHidden = true

		let dataHelper = DataHelper()

		if let array = (window?.rootViewController as? UITabBarController)?.viewControllers {
			for viewController in array {
				if let viewController = viewController as? UINavigationController {
					if let mainViewController = viewController.topViewController as? ParentViewController {
						mainViewController.dataHelper = dataHelper
					}
				}
			}
		}
        
        activeGA()
        
		return true
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
}

//MARK: - GA
extension AppDelegate {
    func activeGA() {
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        //        		let gai = GAI.sharedInstance()
        //        		gai.trackUncaughtExceptions = true // report uncaught exceptions
        //        		gai.logger.logLevel = GAILogLevel.Verbose // remove before app release
    }
}
