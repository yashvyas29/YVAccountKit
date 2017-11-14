//
//  Extensions.swift
//  YVAccountKit
//
//  Created by Yash Vyas on 14/11/17.
//  Copyright © 2017 Yash Vyas. All rights reserved.
//

import UIKit

class Extensions: NSObject {
    
}

extension NSObject {
    func alert(_ message: String) {
        // create the alert
        let alert = UIAlertController(title: "My App", message: message, preferredStyle: .alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // show the alert
        visibleViewController?.present(alert, animated: true, completion: nil)
    }
}

extension UIColor {
    static func colorWithHex(_ hex: UInt) -> UIColor {
        let alpha: CGFloat = CGFloat((hex & 0xff000000) >> 24) / 255
        let red: CGFloat = CGFloat((hex & 0x00ff0000) >> 16) / 255
        let green: CGFloat = CGFloat((hex & 0x0000ff00) >> 8) / 255
        let blue: CGFloat = CGFloat((hex & 0x000000ff) >> 0) / 255
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
