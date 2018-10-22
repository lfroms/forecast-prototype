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
    @IBAction func handleTempHamburgerPress(_ sender: Any) {
        hero.unwindToRootViewController()
    }

    @IBOutlet var chevronGrip: UIChevronGrip!
    @IBOutlet var stationLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidAppear(_ animated: Bool) {
        self.chevronGrip.flip(direction: .down)
    }

    override func viewDidLoad() {
        self.stationLabel.text = (EnvCanada.shared.siteData(in: .English).latestData?.content as! SiteData).location.region.uppercased()
        
        let timestamp = (EnvCanada.shared.siteData(in: .English).latestData?.content as! SiteData).currentConditions.dateTime![1].value.timeStamp
        
        self.lastUpdatedLabel.text = timestamp
            .toDate("yyyyMMddhhmmss")?
            .toFormat("EEEE MMMM d | h:mm a")
        
        EnvCanada.shared.siteData(in: .English).isLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
    }
}
