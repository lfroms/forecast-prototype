//
//  RenderHourlyForecast.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-12-23.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation

extension MainViewController {
    func renderHourlyForecast(_ data: WeatherQuery.Data.Weather) {
        var hourlyForecastItems: [HourlyForecastItem] = []

        data.hourlyForecastGroup?.hourlyForecast.forEach(
            { item in
                let forecastItem = HourlyForecastItem(
                    timeStamp: item.dateTimeUtc,
                    icon: ForecastIcon.forCode(item.iconCode.value ?? "00"),
                    temperature: Temperature.toPreferredUnit(item.temperature.value, round: true),
                    temperatureUnits: Temperature.currentUnit(symbol: true),
                    windSpeed: item.wind.speed.value,
                    windSpeedUnits: item.wind.speed.units,
                    pop: item.lop.value
                )

                hourlyForecastItems.append(forecastItem)
            }
        )

        hourlyForecastsView.dataSourceItems = hourlyForecastItems
    }
}
