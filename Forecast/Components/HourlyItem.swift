//
//  HourlyItem.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-12-23.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation
import UIKit

class HourlyItem: UIView {
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var hourLabel: UILabel!
    @IBOutlet var amPmLabel: UILabel!
    @IBOutlet var iconLabel: UILabel!
    
    @IBOutlet var temperatureContainer: UIView!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var temperatureUnitsLabel: UILabel!
    
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var popContainer: UIView!
    @IBOutlet var popLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("HourlyItem", owner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    override var intrinsicContentSize: CGSize {
        return contentView.frame.size
    }
    
    func with(hour: String, amPm: String, icon: String, temperature: String?, temperatureUnits: String, windSpeed: String?, pop: String?) -> HourlyItem {
        // Icon
        iconLabel.text = icon
        
        // Time
        hourLabel.text = hour
        amPmLabel.text = amPm.lowercased()
        
        // Temperature
        temperatureLabel.text = temperature
        temperatureUnitsLabel.text = temperatureUnits
        
        // Wind Speed
        if windSpeed != nil && windSpeed != "" {
            windSpeedLabel.text = windSpeed
        } else {
            windSpeedLabel.isHidden = true
        }

        // POP Label
        if pop != nil && pop != "" {
            popLabel.text = pop! + "%"
        } else {
            popContainer.isHidden = true
        }
        
        invalidateIntrinsicContentSize()
        
        return self
    }
}
