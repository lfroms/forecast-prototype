//
//  ForecastViewController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-20.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation
import Hero
import UIKit

class ForecastViewController: UIViewController {
    @IBOutlet var stationLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBAction func didPressNowButton(_ sender: UIButton) {
        hero.unwindToRootViewController()
    }
    
    override func viewDidLoad() {
        self.stationLabel.text = (EnvCanada.shared.siteData(in: .English).latestData?.content as! SiteData).location.name.value
        
        let timestamp = (EnvCanada.shared.siteData(in: .English).latestData?.content as! SiteData).currentConditions.dateTime![1].value.timeStamp
        
//        EnvCanada.shared.siteData(in: .English).isLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
    }
}
