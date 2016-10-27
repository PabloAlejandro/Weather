//
//  AlertController.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import UIKit

/**
 *  A generic struct which contains info about an action to display in an alert
 */
struct AlertAction {
    
    enum Style {
        case Default, Cancel, Destructive
    }
    
    typealias Handler = (_ action: AlertAction) -> Void
    
    var title: String
    var style: Style
    var handler: Handler
}

/**
 *  A generic struct which contains info about an alert to display
 */
struct AlertControllerInfo {
    
    enum Style {
        case Alert, ActionSheet
    }
    
    var title: String?
    var message: String?
    var style: Style
    var actions: [AlertAction]
    
}

// MARK: - Generic presentation

extension UIViewController {
    /**
     Present an alert on the receive view controller, according to the presentation style:
     If the presentation style is .Alert, an alert view will be displayed.
     If the presentation style if .ActionSheet, an action sheet will be displayed.
     
     - parameter info:       The struct containing all the info for this alert.
     - parameter animated:   Whether to animate the presentation of this alert (only works for iOS >= 8.0)
     - parameter completion: The handler to call when the presentation is complete (only works for iOS >= 8.0)
     */
    func presentAlertViewController(fromInfo info: AlertControllerInfo, animated: Bool, completion: (()-> Void)?) {
        // create alert controller
        let controller = UIAlertController(info: info)
        // use built-in system presentation
        present(controller, animated: animated, completion: completion)
    }
}

// MARK: Presenting UIAlertController using alert info
@available(iOS 8.0, *)
extension UIAlertController {
    
    /**
     The default initializer to use for creating an alert controller using the info provided
     
     - parameter info: The struct containing all the info for this alert
     
     - returns: A new alert controller which can be presented in any VC
     */
    convenience init(info: AlertControllerInfo) {
        
        // private help to convert a custom style into a system style
        func alertStyle(style: AlertControllerInfo.Style) -> UIAlertControllerStyle {
            switch style {
            case .ActionSheet: return .actionSheet
            case .Alert: return .alert
            }
        }
        
        // private help to convert a custom style into a system style
        func actionStyle(style: AlertAction.Style) -> UIAlertActionStyle {
            switch style {
            case .Cancel: return .cancel
            case .Destructive: return .destructive
            case .Default: return .default
            }
        }
        
        // common init
        self.init(title: info.title, message: info.message, preferredStyle: alertStyle(style: info.style))
        
        // create action
        for action in info.actions {
            // create alert action
            addAction(UIAlertAction(title: action.title, style: actionStyle(style: action.style), handler: { (_) in
                action.handler(action)
            }))
        }
    }
}
