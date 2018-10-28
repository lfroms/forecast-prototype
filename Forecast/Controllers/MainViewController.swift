//
//  ViewController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-15.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Hero
import Siesta
import SnapKit
import SwiftDate
import UIKit

class MainViewController: UIViewController {
    @IBOutlet var lastUpdatedLabel: UILabel!
    @IBOutlet var stationLabel: UILabel!
    @IBOutlet var currentTempLabel: UILabel!
    @IBOutlet var currentConditionLabel: UILabel!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var chevronGrip: UIChevronGrip!
    @IBOutlet var detailsStack: UIStackView!
    
    @IBOutlet var lowTempView: UIView!
    @IBOutlet var lowTempValue: UILabel!
    @IBOutlet var highTempView: UIView!
    @IBOutlet var highTempValue: UILabel!
    
    @IBOutlet var tempModifierView: UIView!
    @IBOutlet var tempModifierLabel: UILabel!
    @IBOutlet var tempModifierValue: UILabel!
    
    @IBOutlet var iconImageView: UIImageView!
    
    @IBAction func didPressHamburger(_ sender: Any) {
        self.fetchNewData()
    }
    
    @IBAction func didPerformPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        let progress = -translation.y / view.bounds.height
        
        switch sender.state {
        case .began:
            present(
                self.storyboard!.instantiateViewController(withIdentifier: "Forecast"),
                animated: true)
            
        case .changed:
            Hero.shared.update(progress)
        default:
            if progress > 0.3 {
                Hero.shared.finish()
                break
            }
            
            if sender.velocity(in: nil).y < -1000 {
                Hero.shared.finish()
                break
            }
            
            Hero.shared.cancel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnvCanada.shared.siteData(in: .English).addObserver(self)
        self.fetchNewData()
    }
    
    func render() {
        let resource = EnvCanada.shared.siteData(in: .English)
        
        if let data = resource.latestData?.content as! SiteData?, resource.isLoading == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.loadingIndicator.stopAnimating()
            }
            
            let cc = data.currentConditions
            let fc = data.forecastGroup.forecast
            
            let timestamp = cc.dateTime![1].value.timeStamp
            
            self.lastUpdatedLabel.text = timestamp
                .toDate("yyyyMMddhhmmss")?
                .toFormat("EEEE MMMM d | h:mm a")
            
            if let tempAsFloat = Float(cc.temperature!.value) {
                self.currentTempLabel.text = tempAsFloat.asRoundedString() + "°"
            }
            
            self.stationLabel.text = data.location.name.value.uppercased()
            self.currentConditionLabel.text = cc.condition
            
            self.addDetailSubviews(cc)
            
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
            
            if let windChill = cc.windChill?.value {
                self.tempModifierView.isHidden = false
                self.tempModifierLabel.text = "WIND CHILL:"
                self.tempModifierValue.text = windChill + "°"
            } else if let humidex = cc.humidex?.value {
                self.tempModifierView.isHidden = false
                self.tempModifierLabel.text = "HUMIDEX:"
                self.tempModifierValue.text = humidex + "°"
            } else {
                self.tempModifierView.isHidden = true
            }
            
            if cc.iconCode != nil {
                self.iconImageView.image = UIImage(named: cc.iconCode!)
            }
        }
    }
    
    func fetchNewData() {
        self.loadingIndicator.startAnimating()
        EnvCanada.shared.siteData(in: .English).load()
    }
}

extension MainViewController: ResourceObserver {
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        self.render()
    }
}

extension Float {
    func asRoundedString() -> String {
        return String(format: "%.0f", self.rounded())
    }
}
