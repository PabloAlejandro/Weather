//
//  LoadingViewPresentable.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import UIKit
import MBProgressHUD

// MARK: - Generic interface

/**
 A status for a loading indicator
 
 - Visible: Loading indicator is visibile on-screen. A text describes an optional message which can de displayed on screen.
 - Hidden:  Loading indicator is not visibile on-screen.
 */
enum LoadingViewStatus {
    case Visible(text: String?)
    case Hidden
}

/**
 *  This describes the behaviour of a class which supports presentation of a loading indicator
 */
protocol LoadingViewPresentable {
    /**
     Update the loading indicator status for this screen
     
     - parameter status:   The new status
     - parameter animated: Whether the consumer requested to animate the transition
     */
    func setLoadingViewStatus(status: LoadingViewStatus, animated: Bool)
}

// MARK: - Extending standard View Controller

extension UIViewController: LoadingViewPresentable {
    /**
     This extention allows any view controller to support presentation of a loading indicator out of the box.
     This behaviour is implemented using the standard MBProgressHUD class.
     Example: viewController.setLoadingViewStatus(.Visible(text: NSLocalizedString("Loading…", message: ""), animated: false)
     Example: viewController.setLoadingViewStatus(.Hidden, animated: true)
     
     - parameter status:   If visibile, a loading indicator will be presented on top of the view hierancy. If hidden, the top-most loading indicator will be removed from the view.
     - parameter animated: If true, the loading indicator will have a standard animation when presented/dismissed.
     */
    func setLoadingViewStatus(status: LoadingViewStatus, animated: Bool) {
        if !isViewLoaded {
            return
        }
        
        switch status {
        case .Hidden:
            MBProgressHUD.hide(for: view, animated: animated)
        case .Visible(let text):
            let loadingView = MBProgressHUD.showAdded(to: view, animated: animated)
            loadingView.label.text = text ?? NSLocalizedString("Loading…", comment: "")
        }
    }
}
