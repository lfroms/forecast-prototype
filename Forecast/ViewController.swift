//
//  ViewController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-15.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Siesta
import SwiftDate
import SWXMLHash
import UIKit

class ViewController: UIViewController {
    @IBOutlet var lastUpdatedLabel: UILabel!
    @IBOutlet var stationLabel: UILabel!
    @IBOutlet var currentTempLabel: UILabel!
    @IBOutlet var currentConditionLabel: UILabel!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    let api = WeatherService()
    
    @IBAction func didPressHamburger(_ sender: Any) {
        // getData()
    }
    
    func render(data: SiteData) {
        let cc = data.currentConditions
        
        let timestamp = cc.dateTime![1].value.timeStamp
        
        self.lastUpdatedLabel.text = timestamp
            .toDate("yyyymmddhhmmss")?
            .toFormat("EEEE MMMM d yyyy | h:mm a")
        
        self.currentTempLabel.text = (cc.temperature != nil) ? cc.temperature!.value + "º" : "--º"
        self.stationLabel.text = data.location.region.uppercased()
        self.currentConditionLabel.text = cc.condition
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.api.siteList.loadIfNeeded()
        
        let site = Site(code: "s0000430", nameEn: "", nameFr: "", provinceCode: "ON")
        
        self.api.siteData(site: site, lang: LanguageCode.english).loadIfNeeded()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.loadingIndicator.startAnimating()
            print(self.api.siteData(site: site, lang: LanguageCode.english).latestData!)
            self.loadingIndicator.stopAnimating()
        }
    }
}
