//
//  RenderCurrentConditions.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-11-07.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Siesta
import SnapKit
import SwiftDate
import UIKit

extension MainViewController {
    func renderCurrentConditions(_ data: SiteData) {
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
    }
    
    func renderMetadata(_ data: SiteData) {
        let cc = data.currentConditions
        self.stationLabel.text = data.location.name.value
        
        if cc.dateTime != nil {
            let timestamp = cc.dateTime?.first(where: { $0.zone == "UTC" })?.value.timeStamp
            
            self.lastUpdatedLabel.text = timestamp?
                .toDate("yyyyMMddhhmmss", region: .UTC)?
                .convertTo(region: .current)
                .toFormat("MMM d h:mm a")
        }
        
//        let codeAsInt = Int(cc.iconCode ?? "0") ?? 0
    }
    
    func renderDetails(_ data: SiteData) {
        let currCond = data.currentConditions
        
        detailsTopRow.subviews.forEach({ $0.removeFromSuperview() })
        detailsBottomRow.subviews.forEach({ $0.removeFromSuperview() })
        
        if currCond.relativeHumidity != nil {
            let humidity = ConditionView().with(
                value: currCond.relativeHumidity?.value,
                units: currCond.relativeHumidity?.units,
                type: "HUMIDITY",
                icon: "tint"
            )
            
            detailsTopRow.addArrangedSubview(humidity)
        }
        
        if currCond.wind != nil {
            let wind = ConditionView().with(
                value: currCond.wind!.direction.value + " " + currCond.wind!.speed.value,
                units: currCond.wind!.speed.units,
                type: "WIND",
                icon: "wind"
            )
            
            detailsTopRow.addArrangedSubview(wind)
            
            if currCond.wind!.gust.value != "" {
                let gust = ConditionView().with(
                    value: currCond.wind!.gust.value,
                    units: currCond.wind!.gust.units,
                    type: "WIND GUST",
                    icon: "arrow-right"
                )
                
                detailsTopRow.addArrangedSubview(gust)
            }
        }
        
        if currCond.visibility != nil {
            let visibility = ConditionView().with(
                value: currCond.visibility?.value,
                units: currCond.visibility?.units,
                type: "VISIBILITY",
                icon: "ruler"
            )
            
            detailsTopRow.addArrangedSubview(visibility)
        }
        
        if currCond.pressure != nil {
            let pressure = ConditionView().with(
                value: currCond.pressure?.value,
                units: currCond.pressure?.units,
                type: "PRESSURE",
                icon: "tachometer-alt"
            )
            
            detailsBottomRow.addArrangedSubview(pressure)
        }
        
        if let windChill = currCond.windChill?.value {
            let windChillView = ConditionView().with(
                value: windChill,
                units: "°",
                type: "WIND CHILL",
                icon: "snowflake"
            )
            detailsBottomRow.addArrangedSubview(windChillView)
            
        } else if let humidex = currCond.humidex?.value {
            let humidexView = ConditionView().with(
                value: humidex,
                units: "°",
                type: "HUMIDEX",
                icon: "sun"
            )
            detailsBottomRow.addArrangedSubview(humidexView)
        }
        
        if currCond.dewpoint != nil {
            let dewpoint = ConditionView().with(
                value: currCond.dewpoint?.value,
                units: "°" + currCond.dewpoint!.units!,
                type: "DEWPOINT",
                icon: "thermometer-half"
            )
            
            detailsBottomRow.addArrangedSubview(dewpoint)
        }
    }
}
