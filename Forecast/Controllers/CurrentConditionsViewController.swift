//
//  CurrentConditionsViewController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-11-07.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

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
    
    @IBAction func didPressForecastButton(_ sender: UIButton) {
        present(
            self.storyboard!.instantiateViewController(withIdentifier: "Forecast"),
            animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnvCanada.shared.siteData(in: .English).addObserver(self)
    }
    
    var useNightMode = false {
        didSet {
            if self.useNightMode != oldValue {
                self.render()
            }
        }
    }
    
    func render() {
        let resource = EnvCanada.shared.siteData(in: .English)
        
        if let data = resource.latestData?.content as! SiteData?, resource.isLoading == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.loadingIndicator.stopAnimating()
            }
            
            let cc = data.currentConditions
            let fc = data.forecastGroup.forecast
            
            if let tempAsFloat = Float(cc.temperature!.value) {
                self.currentTempLabel.text = tempAsFloat.asRoundedString() + "°"
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
                
                let codeAsInt = Int(cc.iconCode!) ?? 0
                
                if codeAsInt > 29 && codeAsInt < 40 {
                    self.useNightMode = true
                } else {
                    self.useNightMode = false
                }
            }
            
//            if self.useNightMode {
//                self.view.backgroundColor = UIColor(red: 0.18, green: 0.19, blue: 0.21, alpha: 1.0)
//                // self.lastUpdatedLabel.textColor = UIColor(named: "SubduedInverted")
//                //
//                self.currentTempLabel.textColor = UIColor(named: "White")
//                self.currentConditionLabel.textColor = UIColor(named: "White")
//                self.loadingIndicator.color = UIColor(named: "White")
//
//                self.lowTempValue.textColor = UIColor(named: "White")
//                self.highTempValue.textColor = UIColor(named: "White")
//
//                self.tempModifierLabel.textColor = UIColor(named: "LightInverted")
//                self.tempModifierValue.textColor = UIColor(named: "White")
//            }
        }
    }
}

extension CurrentConditionsViewController: ResourceObserver {
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        self.loadingIndicator.startAnimating()
        self.render()
    }
}

extension Float {
    func asRoundedString() -> String {
        return String(format: "%.0f", self.rounded())
    }
}
