//
//  RenderCurrentConditions.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-11-07.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import SnapKit
import SwiftDate
import UIKit

extension MainViewController {
    func renderCurrentConditions(_ data: WeatherQuery.Data.Weather) {
        let cc = data.currentConditions
        let fc = data.forecastGroup.forecast
        
        if let temperature = cc.temperature?.value {
            self.currentTempLabel.text = Temperature.toPreferredUnit(temperature, round: true) + "°"
        } else {
            self.currentTempLabel.text = "--°"
        }
        
        if cc.condition != nil, cc.condition != "" {
            self.currentConditionLabel.text = cc.condition
        } else {
            self.currentConditionLabel.text = "Not Observed"
        }
        
        if let forecast = fc.first(where: { $0.period.textForecastName == "Tonight" }),
            let temp = forecast.temperatures.temperature.first?.value {
            self.lowTempView.isHidden = false
            self.lowTempValue.text = Temperature.toPreferredUnit(temp, round: true) + "°"
        } else {
            self.lowTempView.isHidden = true
        }
        
        if let forecast = fc.first(where: { $0.period.textForecastName == "Today" }),
            let temp = forecast.temperatures.temperature.first?.value {
            self.highTempView.isHidden = false
            self.highTempValue.text = Temperature.toPreferredUnit(temp, round: true) + "°"
        } else {
            self.highTempView.isHidden = true
        }
    }
    
    func renderMetadata(_ data: WeatherQuery.Data.Weather) {
        let cc = data.currentConditions
        self.stationLabel.text = data.location.name.value
        
        if cc.dateTime != nil {
            self.lastUpdatedLabel.text = cc.dateTime?.timeStamp?
                .toDate("yyyyMMddHHmmss", region: .UTC)?
                .convertTo(region: .current)
                .toFormat("MMM d 'at' h:mm a", locale: Locales.current)
        }
        
        UIView.animate(
            withDuration: 0.5, delay: 0.0, animations: {
                if let code = cc.iconCode?.value, code != "" {
                    self.view.backgroundColor = UIColor(named: code)
                } else {
                    self.view.backgroundColor = UIColor(named: "06")
                }
            }, completion: nil
        )
        
        if let code = cc.iconCode?.value, code != "" {
            self.weatherGraphic.image = UIImage(named: code + "-image")?.aspectFitImage(inRect: self.weatherGraphic.frame)
        } else {
            self.weatherGraphic.image = UIImage(named: "03-image")?.aspectFitImage(inRect: self.weatherGraphic.frame)
        }
        
        self.weatherGraphic.contentMode = .top
    }
    
    func renderDetails(_ data: WeatherQuery.Data.Weather) throws {
        let cc = data.currentConditions
        
        detailsStack.removeAllSubviews()
        
        if let humidity = cc.relativeHumidity {
            let humidityView = ConditionView().with(
                aux: nil,
                value: humidity.value,
                units: humidity.units,
                type: "HUMIDITY",
                icon: "tint"
            )
            
            if humidity.value != nil {
                try detailsStack.addOrganizedSubview(humidityView)
            }
        }
        
        if let pressure = cc.pressure {
            let pressureView = ConditionView().with(
                aux: nil,
                value: pressure.value,
                units: pressure.units,
                type: "PRESSURE",
                icon: "tachometer-alt"
            )
            
            if pressure.value != nil {
                try detailsStack.addOrganizedSubview(pressureView)
            }
        }
        
        if let windChill = cc.windChill?.value {
            let windChillView = ConditionView().with(
                aux: nil,
                value: Temperature.toPreferredUnit(windChill) + "°",
                units: Temperature.currentUnit(symbol: true),
                type: "WIND CHILL",
                icon: "snowflake"
            )
            
            try detailsStack.addOrganizedSubview(windChillView)
        }
        
        if let humidex = cc.humidex?.value {
            let humidexView = ConditionView().with(
                aux: nil,
                value: Temperature.toPreferredUnit(humidex) + "°",
                units: Temperature.currentUnit(symbol: true),
                type: "HUMIDEX",
                icon: "sun"
            )
            
            try detailsStack.addOrganizedSubview(humidexView)
        }
        
        if let wind = cc.wind {
            let windView = ConditionView().with(
                aux: wind.direction,
                value: wind.speed.value,
                units: wind.speed.units,
                type: "WIND",
                icon: "wind"
            )
            
            if wind.speed.value != nil {
                try detailsStack.addOrganizedSubview(windView)
            }
            
            if wind.gust.value != nil {
                let gust = ConditionView().with(
                    aux: nil,
                    value: cc.wind!.gust.value,
                    units: cc.wind!.gust.units,
                    type: "WIND GUST",
                    icon: "arrow-right"
                )
                
                try detailsStack.addOrganizedSubview(gust)
            }
        }
        
        if let visibility = cc.visibility {
            let visibilityView = ConditionView().with(
                aux: nil,
                value: visibility.value,
                units: visibility.units,
                type: "VISIBILITY",
                icon: "ruler"
            )
            
            if visibility.value != nil {
                try detailsStack.addOrganizedSubview(visibilityView)
            }
        }
        
        if let dewpoint = cc.dewpoint?.value {
            let dewpointView = ConditionView().with(
                aux: nil,
                value: Temperature.toPreferredUnit(dewpoint) + "°",
                units: Temperature.currentUnit(symbol: true),
                type: "DEWPOINT",
                icon: "thermometer-half"
            )
            
            try detailsStack.addOrganizedSubview(dewpointView)
        }
        
        if detailsStack.hasAnyItems() == true {
            detailsScrollView.isHidden = false
            return
        }
        
        detailsScrollView.isHidden = true
    }
}
