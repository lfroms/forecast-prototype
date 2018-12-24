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
                .toDate("yyyyMMddHHmmss", region: .UTC)?
                .convertTo(region: .current)
                .toFormat("MMM d 'at' h:mm a", locale: Locales.current)
        }
        
        UIView.animate(
            withDuration: 0.5, delay: 0.0, animations: {
                self.view.backgroundColor = UIColor(named: cc.iconCode ?? "0")
            }, completion: nil
        )
    }
    
    func renderDetails(_ data: SiteData) throws {
        let currCond = data.currentConditions
        
        detailsStack.removeAllSubviews()
        
        if let humidity = currCond.relativeHumidity {
            let humidityView = ConditionView().with(
                aux: nil,
                value: humidity.value,
                units: humidity.units,
                type: "HUMIDITY",
                icon: "tint"
            )
            
            try detailsStack.addOrganizedSubview(humidityView)
        }
        
        if let pressure = currCond.pressure {
            let pressureView = ConditionView().with(
                aux: nil,
                value: pressure.value,
                units: pressure.units,
                type: "PRESSURE",
                icon: "tachometer-alt"
            )
            
            try detailsStack.addOrganizedSubview(pressureView)
        }
        
        if let windChill = currCond.windChill {
            let windChillView = ConditionView().with(
                aux: nil,
                value: windChill.value,
                units: "°" + (windChill.units ?? "C"),
                type: "WIND CHILL",
                icon: "snowflake"
            )
            
            try detailsStack.addOrganizedSubview(windChillView)
            
        } else if let humidex = currCond.humidex {
            let humidexView = ConditionView().with(
                aux: nil,
                value: humidex.value,
                units: "°" + (humidex.units ?? "C"),
                type: "HUMIDEX",
                icon: "sun"
            )
            
            try detailsStack.addOrganizedSubview(humidexView)
        }
        
        if let wind = currCond.wind {
            let windView = ConditionView().with(
                aux: wind.direction.value,
                value: wind.speed.value,
                units: wind.speed.units,
                type: "WIND",
                icon: "wind"
            )
            
            try detailsStack.addOrganizedSubview(windView)
            
            if currCond.wind!.gust.value != "" {
                let gust = ConditionView().with(
                    aux: nil,
                    value: currCond.wind!.gust.value,
                    units: currCond.wind!.gust.units,
                    type: "WIND GUST",
                    icon: "arrow-right"
                )
                
                try detailsStack.addOrganizedSubview(gust)
            }
        }
        
        if let visibility = currCond.visibility {
            let visibilityView = ConditionView().with(
                aux: nil,
                value: visibility.value,
                units: visibility.units,
                type: "VISIBILITY",
                icon: "ruler"
            )
            
            try detailsStack.addOrganizedSubview(visibilityView)
        }
        
        if let dewpoint = currCond.dewpoint {
            let dewpointView = ConditionView().with(
                aux: nil,
                value: dewpoint.value,
                units: "°" + (dewpoint.units ?? "C"),
                type: "DEWPOINT",
                icon: "thermometer-half"
            )
            
            try detailsStack.addOrganizedSubview(dewpointView)
        }
    }
}
