//
//  ForecastRouting.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import UIKit

class ForecastRouting {
    
    weak var mainViewController: UIViewController!

    func presentInterface(navigationController: UINavigationController, animated: Bool) {
        navigationController.setViewControllers([mainViewController], animated: animated)
    }
    
    func dismissInterface(animated: Bool) {
        guard let nav = mainViewController.navigationController else {
            fatalError("the view controller provided must be contained into a navigation controller")
        }
        nav.popViewController(animated: animated)
    }
    
    func pushSearchesModule(module: SearchesModule) {
        module.presentInterface(viewController: mainViewController)
    }
}
