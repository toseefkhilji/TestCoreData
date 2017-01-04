//
//  UIBarButtonItemExtensions.swift
//  SSTests
//
//  Created by Omar Albeik on 08/12/2016.
//  Copyright © 2016 Omar Albeik. All rights reserved.
//

import UIKit

// MARK: - Methods
public extension UIBarButtonItem {
    
    /// SwifterSwift: Add Target to UIBarButtonItem
    ///
    /// - Parameters:
    ///   - target: target.
    ///   - action: selector to run when button is tapped.
    public func addTargetForAction(target: AnyObject, action: Selector) {
        self.target = target
        self.action = action
    }
    
    
    /// This extenstion is used to hide/show barbutton item
    var hidden: Bool {
        get {
            return !self.isEnabled && self.tintColor == UIColor.clear
        }
        set {
            self.tintColor = newValue ? UIColor.clear : nil
            self.isEnabled = !newValue
        }
    }
}
