//
//  HourlyForecastsViewModel.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-12-23.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation

struct HourlyForecastsViewModel {
    private let hourlyForecastEntries: [WeatherQuery.Data.Weather.HourlyForecastGroup.HourlyForecast]?

    init(_ hourlyForecastEntries: [WeatherQuery.Data.Weather.HourlyForecastGroup.HourlyForecast]?) {
        self.hourlyForecastEntries = hourlyForecastEntries
    }

    var items: [HourlyForecastItem] {
        var hourlyForecastItems: [HourlyForecastItem] = []

        hourlyForecastEntries?.forEach(
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

        return hourlyForecastItems
    }
}
