//
//  ForecastItem.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-11-24.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation
import UIKit

class ForecastItem: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var backdrop: UIStyledView!
    
    @IBOutlet var iconImageView: UIImageView!
    
    @IBOutlet var conditionLabel: UILabel!
    @IBOutlet var dateTimeLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
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
        Bundle.main.loadNibNamed("ForecastItem", owner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    override var intrinsicContentSize: CGSize {
        return contentView.frame.size
    }
    
    func with(iconCode: String?, condition: String, date: String, temperature: String, pop: String?) -> ForecastItem {
        let scheme = UIColor.white
        
        // Icon
        iconImageView.image = UIImage(named: iconCode!)!
        
        // Condition Label
        conditionLabel.text = condition
        conditionLabel.textColor = scheme
        
        // Units Label
        dateTimeLabel.text = date
        dateTimeLabel.textColor = scheme
        
        // Type of Detail Label
        temperatureLabel.text = temperature
        temperatureLabel.textColor = scheme
        
        // POP Label
        if pop != nil && pop != "" {
            popLabel.text = pop! + "%"
            popLabel.textColor = scheme
        } else {
            popLabel.isHidden = true
        }
        
        // Backdrop
        backdrop.backgroundColor = UIColor(
            red: 1.00,
            green: 1.00,
            blue: 1.00,
            alpha: 0.06
        )
        
        contentView.backgroundColor = .white
        
        invalidateIntrinsicContentSize()
        
        return self
    }
}
