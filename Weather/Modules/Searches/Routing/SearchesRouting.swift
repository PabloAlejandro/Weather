//
//  SearchesRouting.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import UIKit

class SearchesRouting {
    
    weak var mainViewController: UIViewController!

    func presentInterface(viewController: UIViewController, animated: Bool) {
        guard let nav = viewController.navigationController else {
            fatalError("the view controller provided must be contained into a navigation controller")
        }
        nav.pushViewController(mainViewController, animated: animated)
    }
    
    func popInterface(animated: Bool) {
        guard let nav = mainViewController.navigationController else {
            fatalError("the view controller provided must be contained into a navigation controller")
        }
        nav.popViewController(animated: animated)
    }
}
