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
    
    var api: WeatherService?

    override func viewDidAppear(_ animated: Bool) {
        self.chevronGrip.flipDown()
    }
    
    override func viewDidLoad() {
        self.stationLabel.text = (api!.siteData(in: .English).latestData?.content as! SiteData).currentConditions.station?.value.uppercased()
    }
}
