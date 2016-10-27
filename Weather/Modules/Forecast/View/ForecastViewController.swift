//
//  ForecastViewController.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import UIKit
import SDWebImage

protocol ForecastView: class, LoadingViewPresentable {
    func updateModel(model: ForecastViewModel?)
    func showErrorMessage(title: String, message: String)
}

class ForecastViewController: UIViewController {
    var presenter: ForecastEventHandler!
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    internal var model: ForecastViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let reloadButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didPressReloadButton))
        navigationItem.rightBarButtonItem = reloadButton
        presenter.viewDidLoad()
    }
    
    internal func didPressReloadButton() {
        presenter.viewDidPressReload()
    }
    
    // MARK - IBAction methods
    
    @IBAction internal func didPressLocationSearchButton(sender: UIButton) {
        presenter.viewDidPressSearch()
    }
}

extension ForecastViewController: ForecastView {
    
    internal func updateModel(model: ForecastViewModel?) {
        self.model = model
        
        guard let value = model else {
            title = nil
            weatherImage.isHidden = true
            humidityLabel.isHidden = true
            pressureLabel.isHidden = true
            return
        }
        
        title = value.location
        
        weatherImage.isHidden = false
        humidityLabel.isHidden = false
        pressureLabel.isHidden = false

        if let url = value.weatherImageURL {
            weatherImage.sd_setImage(with: url)   // Note this is an async request
        }
        
        temperatureLabel.text = value.temperature + value.temperatureUnits.rawValue
        humidityLabel.text = NSLocalizedString("Humidity", comment: "") + ": " + value.humidity + " %"
        pressureLabel.text = NSLocalizedString("Pressure", comment: "") + ": " + value.pressure + " mBar"
    }
    
    internal func showErrorMessage(title: String, message: String) {
        let alertAction: AlertAction = AlertAction(title: NSLocalizedString("Ok", comment: ""), style: .Default) { (_) in }
        let info: AlertControllerInfo = AlertControllerInfo(title: title, message: message, style: .Alert, actions: [alertAction])
        presentAlertViewController(fromInfo: info, animated: true, completion: nil)
    }
}
