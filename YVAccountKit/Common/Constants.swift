//
//  Constants.swift
//  YVAccountKit
//
//  Created by Yash Vyas on 14/11/17.
//  Copyright © 2017 Yash Vyas. All rights reserved.
//

import UIKit

let application = UIApplication.shared
let appDelegate = application.delegate as? AppDelegate
let appWindow = application.keyWindow
let appWindowRootViewController = appWindow?.rootViewController
let visibleViewController = (appWindowRootViewController is UINavigationController) ? (appWindowRootViewController as? UINavigationController)?.visibleViewController : appWindowRootViewController
let lastViewController = (appWindowRootViewController is UINavigationController) ? (appWindowRootViewController as? UINavigationController)?.viewControllers.last : appWindowRootViewController

class Constants: NSObject {
    
}
