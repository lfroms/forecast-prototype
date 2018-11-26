//
//  CurrentConditionsViewController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-11-07.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import NightNight
import Siesta
import SnapKit
import SwiftDate
import UIKit

class CurrentConditionsViewController: UIViewController {
    @IBOutlet var currentTempLabel: UILabel!
    @IBOutlet var currentConditionLabel: UILabel!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet var lowTempView: UIView!
    @IBOutlet var lowTempValue: UILabel!
    @IBOutlet var highTempView: UIView!
    @IBOutlet var highTempValue: UILabel!
    
    @IBOutlet var iconImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnvCanada.shared.siteData(in: .English).addObserver(self)
        self.configureThemeColors()
    }
    
    func render() {
        let resource = EnvCanada.shared.siteData(in: .English)
        
        if let data = resource.latestData?.content as! SiteData?,
            resource.isLoading == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.loadingIndicator.stopAnimating()
            }
            
            let cc = data.currentConditions
            let fc = data.forecastGroup.forecast
            
            if cc.temperature != nil, let tempAsFloat = Float(cc.temperature!.value) {
                let normalized = tempAsFloat > -1 && tempAsFloat <= 0 ? abs(tempAsFloat) : tempAsFloat
                self.currentTempLabel.text = normalized.asRoundedString() + "°"
            }
            
            self.currentConditionLabel.text = cc.condition
            
            if let forecast = fc.first(where: { $0.period.textForecastName == "Tonight" }),
                let temp = forecast.temperatures.first?.value {
                self.lowTempView.isHidden = false
                self.lowTempValue.text = temp + "°"
            } else {
                self.lowTempView.isHidden = true
            }
            
            if let forecast = fc.first(where: { $0.period.textForecastName == "Today" }),
                let temp = forecast.temperatures.first?.value {
                self.highTempView.isHidden = false
                self.highTempValue.text = temp + "°"
            } else {
                self.highTempView.isHidden = true
            }
            
            if cc.iconCode != nil {
                self.iconImageView.image = UIImage(named: cc.iconCode!) ?? UIImage(named: "03")
            }
        }
    }
    
    private func configureThemeColors() {
        let scheme = MixedColor(normal: .black, night: .white)
        
        currentTempLabel.mixedTextColor = scheme
        currentConditionLabel.mixedTextColor = scheme
        loadingIndicator.mixedTintColor = scheme
        
        lowTempValue.mixedTextColor = scheme
        highTempValue.mixedTextColor = scheme
    }
}

extension CurrentConditionsViewController: ResourceObserver {
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        self.loadingIndicator.startAnimating()
        self.render()
    }
}
