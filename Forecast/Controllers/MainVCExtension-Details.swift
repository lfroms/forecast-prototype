//
//  MainVCExtension-Details.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-23.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import UIKit

extension MainViewController {
    func addDetailSubviews(_ currCond: CurrentConditions) {
        detailsStack.subviews.forEach({ $0.removeFromSuperview() })
        
        if currCond.relativeHumidity != nil {
            let humidity = ConditionView().with(
                value: currCond.relativeHumidity?.value,
                units: currCond.relativeHumidity?.units,
                type: "HUMIDITY",
                icon: "tint",
                color: UIColor(red: 0.00, green: 0.64, blue: 1.00, alpha: 1.0)
            )
            
            detailsStack.addArrangedSubview(humidity)
        }
        
        if currCond.pressure != nil {
            let pressure = ConditionView().with(
                value: currCond.pressure?.value,
                units: currCond.pressure?.units,
                type: "PRESSURE",
                icon: "tachometer-alt",
                color: UIColor(red: 0.26, green: 0.79, blue: 0.14, alpha: 1.0)
            )
            
            detailsStack.addArrangedSubview(pressure)
        }
        
        if currCond.wind != nil {
            let wind = ConditionView().with(
                value: currCond.wind?.speed.value,
                units: currCond.wind?.speed.units,
                type: "WIND",
                icon: "wind",
                color: UIColor(red: 0.86, green: 0.02, blue: 0.38, alpha: 1.0)
            )
            
            detailsStack.addArrangedSubview(wind)
        }
        
        if currCond.dewpoint != nil {
            let dewpoint = ConditionView().with(
                value: currCond.dewpoint?.value,
                units: "°" + currCond.dewpoint!.units!,
                type: "DEWPOINT",
                icon: "thermometer-half",
                color: UIColor(red: 0.22, green: 0.02, blue: 0.86, alpha: 1.0)
            )
            
            detailsStack.addArrangedSubview(dewpoint)
        }
        
        if currCond.visibility != nil {
            let visibility = ConditionView().with(
                value: currCond.visibility?.value,
                units: currCond.visibility?.units,
                type: "VISIBILITY",
                icon: "ruler",
                color: UIColor(red: 0.13, green: 0.47, blue: 1.00, alpha: 1.0)
            )
            
            detailsStack.addArrangedSubview(visibility)
        }
    }
}
