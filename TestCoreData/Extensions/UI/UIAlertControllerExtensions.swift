//
//  UIAlertControllerExtensions.swift
//  SwifterSwift
//
//  Created by Omar Albeik on 8/23/16.
//  Copyright © 2016 Omar Albeik. All rights reserved.
//

import UIKit
import AudioToolbox


// MARK:
public extension UIViewController {
//    public func presentAlert(style: UIAlertControllerStyle = .Alert, title: String?, message: String?, actionTitles: [String]?, handler: ActionHandler? = nil) -> UIAlertController {
//        return UIAlertController.presentFromViewController(self, style: style, title: title, message: message, actionTitles: actionTitles, handler: handler)
//    }
//    
//    public func presentAlert(style: UIAlertControllerStyle = .Alert, title: String?, message: String?, attributedActionTitles: [AttributedActionTitle]?, handler: ActionHandler? = nil) -> UIAlertController {
//        return UIAlertController.presentFromViewController(self, style: style, title: title, message: message, attributedActionTitles: attributedActionTitles, handler: handler)
//    }
    
    // Get ViewController in top present level
    internal var topPresentedViewController: UIViewController? {
        get {
            var target: UIViewController? = self
            while (target?.presentedViewController != nil) {
                target = target?.presentedViewController
            }
            return target
        }
    }
    
    // Get top VisibleViewController from ViewController stack in same present level.
    // It should be topViewController if self is a UINavigationController instance
    // It should be selectedViewController if self is a UITabBarContrller instance
    internal var topVisibleViewController: UIViewController? {
        get {
            if let nav = self as? UINavigationController {
                return nav.topViewController?.topVisibleViewController
            }
            else if let tabBar = self as? UITabBarController {
                return tabBar.selectedViewController?.topVisibleViewController
            }
            return self
        }
    }
    
    // Combine both topPresentedViewController and topVisibleViewController methods, to get top visible viewcontroller in top present level
    internal var topMostViewController: UIViewController? {
        get {
            return self.topPresentedViewController?.topVisibleViewController
        }
    }
}

// MARK: - Methods
public extension UIAlertController {
	
	/// SwifterSwift: Present alert view controller in the current view controller.
	///
	/// - Parameters:
	///   - animated: set true to animate presentation of alert controller (default is true).
	///   - vibrate: set true to vibrate the device while presenting the alert (default is false).
	///   - completion: an optional completion handler to be called after presenting alert controller (default is nil).
	public func show(animated: Bool = true, vibrate: Bool = false, completion: (() -> Void)? = nil) {
        
        
        if let rootVC = getTopViewController(){
            
            rootVC.present(self, animated: animated, completion: completion)
            if vibrate {
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            }
        }
        
		
	}
	
    
    func getTopViewController() -> UIViewController? {
        var topViewController = UIApplication.shared.delegate!.window!!.rootViewController!
        while (topViewController.presentedViewController != nil) {
            topViewController = topViewController.presentedViewController!
        }
        return topViewController
    }
    
	/// SwifterSwift: Add an action to Alert
	///
	/// - Parameters:
	///   - title: action title
	///   - style: action style (default is UIAlertActionStyle.default)
	///   - isEnabled: isEnabled status for action (default is true)
	///   - handler: optional action handler to be called when button is tapped (default is nil)
	/// - Returns: action created by this method
	@discardableResult func addAction(title: String, style: UIAlertActionStyle = .default, isEnabled: Bool = true, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
		let action = UIAlertAction(title: title, style: style, handler: handler)
		action.isEnabled = isEnabled
		self.addAction(action)
		return action
	}
	
	/// SwifterSwift: Add a text field to Alert
	///
	/// - Parameters:
	///   - text: text field text (default is nil)
	///   - placeholder: text field placeholder text (default is nil)
	///   - editingChangedTarget: an optional target for text field's editingChanged
	///   - editingChangedSelector: an optional selector for text field's editingChanged
	func addTextField(text: String? = nil, placeholder: String? = nil, editingChangedTarget: Any?, editingChangedSelector: Selector?) {
		addTextField { tf in
			tf.text = text
			tf.placeholder = placeholder
			if let target = editingChangedTarget, let selector = editingChangedSelector {
				tf.addTarget(target, action: selector, for: .editingChanged)
			}
		}
	}
	
}


// MARK: - Initializers
extension UIAlertController {
	
	/// SwifterSwift: Create new alert view controller with default OK action.
	///
	/// - Parameters:
	///   - title: alert controller's title.
	///   - message: alert controller's message (default is nil).
	///   - defaultActionButtonTitle: default action button title (default is "OK")
	///   - tintColor: alert controller's tint color (default is nil)
	public convenience init(title: String, message: String? = nil, defaultActionButtonTitle: String = "OK", tintColor: UIColor? = nil) {
		self.init(title: title, message: message, preferredStyle: .alert)
		let defaultAction = UIAlertAction(title: defaultActionButtonTitle, style: .default, handler: nil)
		self.addAction(defaultAction)
		if let color = tintColor {
			self.view.tintColor = color
		}
	}
	
	/// SwifterSwift: Create new error alert view controller from Error with default OK action.
	///
	/// - Parameters:
	///   - title: alert controller's title (default is "Error").
	///   - error: error to set alert controller's message to it's localizedDescription.
	///   - defaultActionButtonTitle: default action button title (default is "OK")
	///   - tintColor: alert controller's tint color (default is nil)
	public convenience init(title: String = "Error", error: Error, defaultActionButtonTitle: String = "OK", tintColor: UIColor? = nil) {
		self.init(title: title, message: error.localizedDescription, preferredStyle: .alert)
		let defaultAction = UIAlertAction(title: defaultActionButtonTitle, style: .default, handler: nil)
		self.addAction(defaultAction)
		if let color = tintColor {
			self.view.tintColor = color
		}
	}
	
}

