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
    @IBOutlet var chevronGrip: UIChevronGrip!
    
    let api = WeatherService()
    
    @IBAction func didPressHamburger(_ sender: Any) {
        self.fetchNewData()
    }
    
    @IBAction func touchedChevronGrip(_ sender: Any) {
        self.chevronGrip.flipMiddle()
    }
    
    @IBAction func releasedChevronGrip(_ sender: Any) {
        // if current conditions
        self.chevronGrip.flipUp()
        
        // if forecast
        // self.chevronGrip.flipDown()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.api.siteData(in: .English).addObserver(self)
        self.fetchNewData()
    }
    
    func render() {
        let resource = self.api.siteData(in: .English)
        
        if let data = resource.latestData?.content as! SiteData?, resource.isLoading == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.loadingIndicator.stopAnimating()
            }
            
            let cc = data.currentConditions
            
            let timestamp = cc.dateTime![1].value.timeStamp
            
            self.lastUpdatedLabel.text = timestamp
                .toDate("yyyymmddhhmmss")?
                .toFormat("EEEE MMMM d yyyy | h:mm a")
            
            self.currentTempLabel.text = (cc.temperature != nil) ? cc.temperature!.value + "º" : "--º"
            self.stationLabel.text = data.location.region.uppercased()
            self.currentConditionLabel.text = cc.condition
        }
    }
    
    func fetchNewData() {
        self.loadingIndicator.startAnimating()
        self.api.siteData(in: .English).load()
    }
}

extension ViewController: ResourceObserver {
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        self.render()
    }
}
