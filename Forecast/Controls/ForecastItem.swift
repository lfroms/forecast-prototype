//
//  ForecastItem.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-11-24.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation
import NightNight
import UIKit

class ForecastItem: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var backdrop: UIStyledView!
    
    @IBOutlet var iconImageView: UIImageView!
    
    @IBOutlet var conditionLabel: UILabel!
    @IBOutlet var dateTimeLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    
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
        contentView.frame = self.bounds
        self.addSubview(contentView)
    }
    
    override var intrinsicContentSize: CGSize {
        return contentView.frame.size
    }
    
    func with(iconCode: String?, condition: String, date: String, temperature: String) -> ForecastItem {
        let scheme = MixedColor(normal: .black, night: .white)
        
        // Icon
        if iconCode != nil {
            iconImageView.image = UIImage(named: iconCode ?? "03")
        }
        
        // Condition Label
        conditionLabel.text = condition
        conditionLabel.mixedTextColor = scheme
        
        // Units Label
        dateTimeLabel.text = date
        dateTimeLabel.mixedTextColor = scheme
        
        // Type of Detail Label
        temperatureLabel.text = temperature
        temperatureLabel.mixedTextColor = scheme
        
        // Backdrop
        backdrop.mixedBackgroundColor =
            MixedColor(
                normal: UIColor(
                    red: 0.00,
                    green: 0.00,
                    blue: 0.00,
                    alpha: 0.02
                ),
                night: UIColor(
                    red: 1.00,
                    green: 1.00,
                    blue: 1.00,
                    alpha: 0.06
                )
            )
        
        contentView.mixedBackgroundColor = MixedColor(normal: .white, night: .black)
        
        invalidateIntrinsicContentSize()
        
        return self
    }
}
