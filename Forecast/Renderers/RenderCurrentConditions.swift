//
//  RenderCurrentConditions.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-11-07.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import SwiftDate
import UIKit

extension MainViewController {
    func renderOverview(_ data: WeatherQuery.Data.Weather) {
        let cc = data.currentConditions
        let fc = data.forecastGroup.forecast
        
        // MARK: - Current Temperature 🌡
        
        let mainTemperature = Temperature.toPreferredUnit(cc.temperature?.value, round: true)
        overviewView.temperature = mainTemperature
        
        // MARK: - Current Condition ⛅️
        
        overviewView.currentCondition = cc.condition
        
        // MARK: - Forecast High ⇡
        
        let forecastHigh =
            fc.first(where: { $0.period.textForecastName == "Today" })?
            .temperatures.temperature.first?.value
        
        overviewView.highTemp = forecastHigh
        
        // MARK: - Forecast Low ⇣
        
        let forecastLow =
            fc.first(where: { $0.period.textForecastName == "Tonight" })?
            .temperatures.temperature.first?.value
        
        overviewView.lowTemp = forecastLow
        
        // MARK: - Date and Time 📆
        
        overviewView.dateStamp = cc.dateTime?.timeStamp
        
        // MARK: - Station Name 📡
        
        overviewView.stationName = data.location.name.value
    }
    
    func renderMetadata(_ data: WeatherQuery.Data.Weather) {
        let cc = data.currentConditions
        
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
            self.illustration.image = UIImage(named: code + "-image")?.aspectFitImage(inRect: self.illustration.frame)
        } else {
            self.illustration.image = UIImage(named: "03-image")?.aspectFitImage(inRect: self.illustration.frame)
        }
        
        self.illustration.contentMode = .top
    }
    
    func renderObservations(_ data: WeatherQuery.Data.Weather) {
        let cc = data.currentConditions
        
        var observations: [ObservationItem] = []
        
        // MARK: - Humidity 💧
        
        if let humidity = cc.relativeHumidity,
            let value = humidity.value,
            let units = humidity.units {
            let item = ObservationItem(
                icon: "tint",
                value: value,
                units: units,
                description: "Humidity",
                prefix: nil
            )
            
            observations.append(item)
        }
        
        // MARK: - Atmospheric Pressure 📈
        
        if let pressure = cc.pressure,
            let value = pressure.value {
            let item = ObservationItem(
                icon: "tachometer-alt",
                value: value,
                units: pressure.units,
                description: "Pressure",
                prefix: nil
            )
            
            observations.append(item)
        }
        
        // MARK: - Wind Chill ❄️
        
        if let windChill = cc.windChill,
            let value = windChill.value {
            let item = ObservationItem(
                icon: "snowflake",
                value: Temperature.toPreferredUnit(value, round: true),
                units: Temperature.currentUnit(symbol: true),
                description: "Wind Chill",
                prefix: nil
            )
            
            observations.append(item)
        }
        
        // MARK: - Humidex ☀️
        
        if let humidex = cc.humidex,
            let value = humidex.value {
            let item = ObservationItem(
                icon: "sun",
                value: Temperature.toPreferredUnit(value),
                units: Temperature.currentUnit(symbol: true),
                description: "Humidex",
                prefix: nil
            )
            
            observations.append(item)
        }
        
        // MARK: - Wind 💨
        
        if let wind = cc.wind {
            if let speed = wind.speed.value {
                let item = ObservationItem(
                    icon: "wind",
                    value: speed,
                    units: wind.speed.units,
                    description: "Wind",
                    prefix: wind.direction
                )
                
                observations.append(item)
            }
            
            if let gust = wind.gust.value {
                let item = ObservationItem(
                    icon: "arrow-right",
                    value: gust,
                    units: wind.gust.units,
                    description: "Wind Gust",
                    prefix: nil
                )
                
                observations.append(item)
            }
        }
        
        // MARK: - Visibility 📏
        
        if let visibility = cc.visibility,
            let value = visibility.value {
            let item = ObservationItem(
                icon: "ruler",
                value: value,
                units: visibility.units,
                description: "Visibility",
                prefix: nil
            )
            
            observations.append(item)
        }
        
        // MARK: - Dewpoint 🌡
        
        if let dewpoint = cc.dewpoint,
            let value = dewpoint.value {
            let item = ObservationItem(
                icon: "thermometer-half",
                value: Temperature.toPreferredUnit(value),
                units: Temperature.currentUnit(symbol: true),
                description: "Dewpoint",
                prefix: nil
            )
            
            observations.append(item)
        }
        
        observationsView.isHidden = observations.isEmpty
        observationsView.dataSourceItems = observations
    }
}
