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
        detailsTopRow.subviews.forEach({ $0.removeFromSuperview() })
        detailsBottomRow.subviews.forEach({ $0.removeFromSuperview() })
        
        if currCond.relativeHumidity != nil {
            let humidity = ConditionView().with(
                value: currCond.relativeHumidity?.value,
                units: currCond.relativeHumidity?.units,
                type: "HUMIDITY",
                icon: "tint",
                color: UIColor(red: 0.00, green: 0.64, blue: 1.00, alpha: 1.0)
            )
            
            detailsTopRow.addArrangedSubview(humidity)
        }
        
        if currCond.wind != nil {
            let wind = ConditionView().with(
                value: currCond.wind!.direction.value + " " + currCond.wind!.speed.value,
                units: currCond.wind!.speed.units,
                type: "WIND",
                icon: "wind",
                color: UIColor(red: 0.86, green: 0.02, blue: 0.38, alpha: 1.0)
            )
            
            detailsTopRow.addArrangedSubview(wind)
            
            if currCond.wind!.gust.value != "" {
                let gust = ConditionView().with(
                    value: currCond.wind!.gust.value,
                    units: currCond.wind!.gust.units,
                    type: "WIND GUST",
                    icon: "arrow-right",
                    color: UIColor(red: 0.26, green: 0.79, blue: 0.14, alpha: 1.0)
                )
                
                detailsTopRow.addArrangedSubview(gust)
            }
        }
        
        if currCond.visibility != nil {
            let visibility = ConditionView().with(
                value: currCond.visibility?.value,
                units: currCond.visibility?.units,
                type: "VISIBILITY",
                icon: "ruler",
                color: UIColor(red: 0.13, green: 0.47, blue: 1.00, alpha: 1.0)
            )
            
            detailsTopRow.addArrangedSubview(visibility)
        }
        
        if currCond.pressure != nil {
            let pressure = ConditionView().with(
                value: currCond.pressure?.value,
                units: currCond.pressure?.units,
                type: "PRESSURE",
                icon: "tachometer-alt",
                color: UIColor(red: 0.26, green: 0.79, blue: 0.14, alpha: 1.0)
            )
            
            detailsBottomRow.addArrangedSubview(pressure)
        }
        
        if let windChill = currCond.windChill?.value {
            let windChillView = ConditionView().with(
                value: windChill,
                units: "°",
                type: "WIND CHILL",
                icon: "snowflake",
                color: UIColor(red: 0.00, green: 0.64, blue: 1.00, alpha: 1.0)
            )
            detailsBottomRow.addArrangedSubview(windChillView)
            
        } else if let humidex = currCond.humidex?.value {
            let humidexView = ConditionView().with(
                value: humidex,
                units: "°",
                type: "HUMIDEX",
                icon: "sun",
                color: UIColor(red: 1.00, green: 0.60, blue: 0.00, alpha: 1.0)
            )
            detailsBottomRow.addArrangedSubview(humidexView)
        }
        
        if currCond.dewpoint != nil {
            let dewpoint = ConditionView().with(
                value: currCond.dewpoint?.value,
                units: "°" + currCond.dewpoint!.units!,
                type: "DEWPOINT",
                icon: "thermometer-half",
                color: UIColor(red: 0.22, green: 0.02, blue: 0.86, alpha: 1.0)
            )
            
            detailsBottomRow.addArrangedSubview(dewpoint)
        }
    }
}
