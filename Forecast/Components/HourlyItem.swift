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
    @IBOutlet var iconLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var unitsLabel: UILabel!
    @IBOutlet var popLabel: UILabel!
    
    @IBOutlet var temperatureContainer: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ForecastItem", owner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    override var intrinsicContentSize: CGSize {
        return contentView.frame.size
    }
    
    func with(icon: String, day: String, temperature: String?, units: String, description: String?, pop: String?) -> HourlyItem {
        // Icon
        //iconLabel.text = icon
        
        // Day Label
        dayLabel.text = day
        
        // Temperature Label
        if temperature != nil, temperature != "" {
            temperatureLabel.text = temperature
            unitsLabel.text = units
            
        } else {
            temperatureContainer.isHidden = true
        }
        
        // Description
        if description != nil, description != "" {
            descriptionLabel.text = description
        } else {
            descriptionLabel.isHidden = true
        }
        
        // POP Label
        if pop != nil && pop != "" {
            popLabel.text = pop! + "%"
        } else {
            popLabel.isHidden = true
        }
        
        invalidateIntrinsicContentSize()
        
        return self
    }
}
