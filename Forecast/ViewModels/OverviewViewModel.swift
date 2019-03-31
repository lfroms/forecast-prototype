//
//  OverviewViewModel.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-30.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation

struct OverviewViewModel {
    let weather: WeatherQuery.Data.Weather
    
    init(_ weather: WeatherQuery.Data.Weather) {
        self.weather = weather
    }
    
    var data: OverviewData {
        let cc = weather.currentConditions
        let fc = weather.forecastGroup.forecast
        
        // MARK: - Current Temperature 🌡
        
        let mainTemperature = Temperature.toPreferredUnit(cc.temperature?.value, round: true)
        
        // MARK: - Current Condition ⛅️
        
        let currentCondition = cc.condition
        
        // MARK: - Forecast High ⇡
        
        let forecastHigh =
            fc.first(where: { $0.period.textForecastName == "Today" })?
            .temperatures.temperature.first?.value
        
        // MARK: - Forecast Low ⇣
        
        let forecastLow =
            fc.first(where: { $0.period.textForecastName == "Tonight" })?
            .temperatures.temperature.first?.value
        
        // MARK: - Date and Time 📆
        
        let dateStamp = cc.dateTime?.timeStamp
        
        // MARK: - Station Name 📡
        
        let stationName = weather.location.name.value
        
        // MARK: - Generate ViewModel
        
        let overviewData = OverviewData(
            stationName: stationName,
            temperature: mainTemperature,
            highTemp: forecastHigh,
            lowTemp: forecastLow,
            currentCondition: currentCondition,
            date: dateStamp
        )
        
        return overviewData
    }
}
