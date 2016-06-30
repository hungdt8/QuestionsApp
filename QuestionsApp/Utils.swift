//
//  Util.swift
//  MobilePOS
//
//  Created by Hungld on 1/20/16.
//  Copyright © 2016 Hungld. All rights reserved.
//

import Foundation
import UIKit
import JLToast
import SpeedLog
//import EZAlertController

func showMessage(message: String) {
	let toast = JLToast.makeText(message, duration: 4.0)
	toast.show()
}

func messageForError(error: NSError) -> String {
	let errorCode = error.code
	switch errorCode {
	case NSURLErrorBadURL:
		return NSLocalizedString("Connection server has problem (bad URL).", comment: "")
	case NSURLErrorTimedOut:
		return NSLocalizedString("Connection server time out. Please check your Internet and try again.", comment: "")
	case NSURLErrorCannotFindHost:
		return NSLocalizedString("Connection server has problem (can not find host).", comment: "")
	case NSURLErrorCannotConnectToHost:
		return NSLocalizedString("Connection server has problem (can not connect to host).", comment: "")
	case NSURLErrorNetworkConnectionLost:
		return NSLocalizedString("Network connection lost. Please check your Internet and try again.", comment: "")
	case NSURLErrorNotConnectedToInternet:
		return NSLocalizedString("Not connected to Internet. Please check your Internet and try again.", comment: "")
	default:
		return error.localizedDescription
	}
}

func getDeviceInterfaceIdiom() -> UIUserInterfaceIdiom {
	let userInterfaceIdiom = UIDevice.currentDevice().userInterfaceIdiom
	return userInterfaceIdiom
}

func isIPad() -> Bool {
	return (getDeviceInterfaceIdiom() == .Pad) ? true : false
}

func isSimulator() -> Bool {
	#if arch(x86_64)
		return true
	#else
		return false
	#endif
}

func IS_RETINA() -> Bool {
	return UIScreen.mainScreen().scale == 2.0
}

func windowWidth() -> CGFloat {
	let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
	return (appDelegate?.window?.frame.size.width) ?? 0.0
}

func windowHeight() -> CGFloat {
	let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
	return appDelegate?.window?.frame.size.height ?? 0
}

// MARK: - Get Device infor
func getImeiDevice() -> String {
	if isSimulator() {
		return "simulator"
	} else {
		let device = UIDevice.currentDevice()
		var uuidString = ""
		if let uuid = device.identifierForVendor?.UUIDString {
			uuidString = uuid
		}
		let identifier = "\(uuidString)"
		return identifier
	}
}

func getPlatformString() -> String {
	var size: Int = 0 // as Ben Stahl noticed in his answer
	sysctlbyname("hw.machine", nil, &size, nil, 0)
	var machine = [CChar](count: Int(size), repeatedValue: 0)
	sysctlbyname("hw.machine", &machine, &size, nil, 0)
	if let platfom = String.fromCString(machine) {
		return platfom
	} else {
		return ""
	}
}

func getAppVersion() -> String {
	let dicInfo = NSBundle.mainBundle().infoDictionary
	if let appversion = dicInfo?["CFBundleShortVersionString"] as? String {
		return appversion
	} else {
		return ""
	}
}

func getDeviceModel() -> String {
	let platformString = getPlatformString()
	return platformString
}
