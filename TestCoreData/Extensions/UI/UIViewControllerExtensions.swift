//
//  UIViewControllerExtensions.swift
//  SwifterSwift
//
//  Created by Emirhan Erdogan on 07/08/16.
//  Copyright © 2016 Omar Albeik. All rights reserved.
//

import UIKit

// MARK: - Properties
public extension UIViewController {
	
	/// SwifterSwift: Check if ViewController is onscreen and not hidden.
	public var isVisible: Bool {
		// http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
		return self.isViewLoaded && view.window != nil
	}
	
	/// SwifterSwift: NavigationBar in a ViewController.
	public var navigationBar: UINavigationBar? {
		return navigationController?.navigationBar
	}
	
}

// MARK: - Methods
public extension UIViewController {
	
	/// SwifterSwift: Assign as listener to notification.
	///
	/// - Parameters:
	///   - name: notification name.
	///   - selector: selector to run with notified.
	public func addNotificationObserver(name: Notification.Name, selector: Selector) {
		NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
	}
	
	/// SwifterSwift: Unassign as listener to notification.
	///
	/// - Parameter name: notification name.
	public func removeNotificationObserver(name: Notification.Name) {
		NotificationCenter.default.removeObserver(self, name: name, object: nil)
	}
	
	/// SwifterSwift: Unassign as listener from all notifications.
	public func removeNotificationsObserver() {
		NotificationCenter.default.removeObserver(self)
	}
	
}


public extension UIViewController{
    
    /// Get viewcontroller instance specifying the storyboard and controller identifier
    static func viewController(instoryboard storyboard:String, withController identifier:String) -> UIViewController {
        
        guard !storyboard.isEmpty, !identifier.isEmpty else {
            print(" Storyboard or ViewContrroler Id is empty")
            fatalError("Storyboard or ViewContrroler Id is empty")
        }
        
        return UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
}