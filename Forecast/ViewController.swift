//
//  ViewController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-15.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

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
        
        let site = Site(
            code: "s0000430",
            nameEn: "Ottawa (Kanata - Orléans)",
            nameFr: "Ottawa (Kanata - Orléans)",
            provinceCode: "ON"
        )
        
        site.save()
        
        let newSite = site.load()
        
        self.api.siteData(site: newSite, lang: LanguageCode.english).load()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.loadingIndicator.startAnimating()
            self.render(data: self.api.siteData(site: newSite, lang: LanguageCode.english).latestData as! SiteData)
            self.loadingIndicator.stopAnimating()
        }
    }
}
