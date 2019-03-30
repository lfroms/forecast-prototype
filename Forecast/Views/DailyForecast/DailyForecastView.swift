//
//  DailyForecastView.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-11-24.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation
import UIKit

struct DailyForecastItem {
    let icon: String
    let day: String
    let temperature: String
    let temperatureUnits: String
    let description: String?
    let pop: String?
}

class DailyForecastView: UIView {
    @IBOutlet private var contentView: UIView!
    
    @IBOutlet private var iconLabel: UILabel!
    @IBOutlet private var dayLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var temperatureLabel: UILabel!
    @IBOutlet private var unitsLabel: UILabel!
    @IBOutlet private var popLabel: UILabel!
    @IBOutlet private var popContainer: UIView!
    @IBOutlet private var temperatureContainer: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let className = String(describing: type(of: self))
        Bundle.main.loadNibNamed(className, owner: self, options: nil)
        contentView.fixInView(self, followsLayoutMargins: false)
    }
    
    func configure(with item: DailyForecastItem) {
        iconLabel.text = item.icon
        dayLabel.text = item.day
        
        temperatureLabel.text = item.temperature
        unitsLabel.text = item.temperatureUnits
        temperatureContainer.isHidden = item.temperature.isEmpty
        
        descriptionLabel.text = item.description
        descriptionLabel.isHidden = item.description?.isEmpty ?? true
        
        if let pop = item.pop {
            popLabel.text = pop + "%"
        }
        
        popContainer.isHidden = item.pop?.isEmpty ?? true
    }
}
