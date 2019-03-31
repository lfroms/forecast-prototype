//
//  ObservationsViewModel.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-30.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation

struct ObservationsViewModel {
    let currentConditions: WeatherQuery.Data.Weather.CurrentCondition
    
    init(_ currentConditions: WeatherQuery.Data.Weather.CurrentCondition) {
        self.currentConditions = currentConditions
    }
    
    var items: [ObservationItem] {
        let cc = currentConditions
        
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
        
        return observations
    }
}
