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
        let fc = data.forecastGroup?.forecast
        
        if cc?.temperature != nil, let tempAsFloat = Float(cc!.temperature!.value) {
            let normalized = tempAsFloat > -1 && tempAsFloat <= 0 ? abs(tempAsFloat) : tempAsFloat
            self.currentTempLabel.text = normalized.asRoundedString() + "°"
        }
        
        if cc?.condition != nil, cc?.condition != "" {
            self.currentConditionLabel.text = cc?.condition
        } else {
            self.currentConditionLabel.text = "Not Observed"
        }
        
        if let forecast = fc?.first(where: { $0.period.textForecastName == "Tonight" }),
            let temp = forecast.temperatures?.first?.value {
            self.lowTempView.isHidden = false
            self.lowTempValue.text = temp + "°"
        } else {
            self.lowTempView.isHidden = true
        }
        
        if let forecast = fc?.first(where: { $0.period.textForecastName == "Today" }),
            let temp = forecast.temperatures?.first?.value {
            self.highTempView.isHidden = false
            self.highTempValue.text = temp + "°"
        } else {
            self.highTempView.isHidden = true
        }
    }
    
    func renderMetadata(_ data: SiteData) {
        let cc = data.currentConditions
        self.stationLabel.text = data.location.name.value
        
        if cc?.dateTime != nil {
            let timestamp = cc?.dateTime?.first(where: { $0.zone == "UTC" })?.value.timeStamp
            
            self.lastUpdatedLabel.text = timestamp?
                .toDate("yyyyMMddHHmmss", region: .UTC)?
                .convertTo(region: .current)
                .toFormat("MMM d 'at' h:mm a", locale: Locales.current)
        }
        
        UIView.animate(
            withDuration: 0.5, delay: 0.0, animations: {
                if let code = cc?.iconCode, code != ""  {
                    self.view.backgroundColor = UIColor(named: code)
                } else {
                    self.view.backgroundColor = UIColor(named: "06")
                }
            }, completion: nil
        )
        
        if let code = cc?.iconCode, code != ""  {
            self.weatherGraphic.image = UIImage(named: code)?.aspectFitImage(inRect: self.weatherGraphic.frame)
        } else {
            self.weatherGraphic.image = UIImage(named: "03")?.aspectFitImage(inRect: self.weatherGraphic.frame)
        }
        
        self.weatherGraphic.contentMode = .top
    }
    
    func renderDetails(_ data: SiteData) throws {
        let cc = data.currentConditions
        
        detailsStack.removeAllSubviews()
        
        if let humidity = cc?.relativeHumidity {
            let humidityView = ConditionView().with(
                aux: nil,
                value: humidity.value,
                units: humidity.units,
                type: "HUMIDITY",
                icon: "tint"
            )
            
            if humidity.value != "" {
                try detailsStack.addOrganizedSubview(humidityView)
            }
        }
        
        if let pressure = cc?.pressure {
            let pressureView = ConditionView().with(
                aux: nil,
                value: pressure.value,
                units: pressure.units,
                type: "PRESSURE",
                icon: "tachometer-alt"
            )
            
            if pressure.value != "" {
                try detailsStack.addOrganizedSubview(pressureView)
            }
        }
        
        if let windChill = cc?.windChill {
            let windChillView = ConditionView().with(
                aux: nil,
                value: windChill.value,
                units: "°" + (windChill.units ?? "C"),
                type: "WIND CHILL",
                icon: "snowflake"
            )
            
            if windChill.value != "" {
                try detailsStack.addOrganizedSubview(windChillView)
            }
            
        } else if let humidex = cc?.humidex {
            let humidexView = ConditionView().with(
                aux: nil,
                value: humidex.value,
                units: "°" + (humidex.units ?? "C"),
                type: "HUMIDEX",
                icon: "sun"
            )
            
            if humidex.value != "" {
                try detailsStack.addOrganizedSubview(humidexView)
            }
        }
        
        if let wind = cc?.wind {
            let windView = ConditionView().with(
                aux: wind.direction.value,
                value: wind.speed.value,
                units: wind.speed.units,
                type: "WIND",
                icon: "wind"
            )
            
            if wind.speed.value != "" {
                try detailsStack.addOrganizedSubview(windView)
            }
            
            if cc?.wind!.gust.value != "" {
                let gust = ConditionView().with(
                    aux: nil,
                    value: cc?.wind!.gust.value,
                    units: cc?.wind!.gust.units,
                    type: "WIND GUST",
                    icon: "arrow-right"
                )
                
                if wind.gust.value != "" {
                    try detailsStack.addOrganizedSubview(gust)
                }
            }
        }
        
        if let visibility = cc?.visibility {
            let visibilityView = ConditionView().with(
                aux: nil,
                value: visibility.value,
                units: visibility.units,
                type: "VISIBILITY",
                icon: "ruler"
            )
            
            if visibility.value != "" {
                try detailsStack.addOrganizedSubview(visibilityView)
            }
        }
        
        if let dewpoint = cc?.dewpoint {
            let dewpointView = ConditionView().with(
                aux: nil,
                value: dewpoint.value,
                units: "°" + (dewpoint.units ?? "C"),
                type: "DEWPOINT",
                icon: "thermometer-half"
            )
            
            if dewpoint.value != "" {
                try detailsStack.addOrganizedSubview(dewpointView)
            }
        }
        
        if cc != nil && detailsStack.hasAnyItems() == true {
            detailsScrollView.isHidden = false
            return
        }
        
        detailsScrollView.isHidden = true
    }
}
