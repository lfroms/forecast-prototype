//
//  DailyForecastViewModel.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-12-23.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation

struct DailyForecastsViewModel {
    private let forecastEntries: [WeatherQuery.Data.Weather.ForecastGroup.Forecast]

    init(_ forecastEntries: [WeatherQuery.Data.Weather.ForecastGroup.Forecast]) {
        self.forecastEntries = forecastEntries
    }

    var items: [DailyForecastItem] {
        var dailyForecastItems: [DailyForecastItem] = []

        for item in forecastEntries {
            let temperature = item.temperatures.temperature.first?.value ?? ""

            let forecastItem = DailyForecastItem(
                icon: ForecastIcon.forCode(item.abbreviatedForecast.iconCode?.value ?? "00"),
                day: item.period.textForecastName,
                temperature: Temperature.toPreferredUnit(temperature, round: true),
                temperatureUnits: Temperature.currentUnit(symbol: true),
                description: item.abbreviatedForecast.textSummary,
                pop: item.abbreviatedForecast.pop?.value
            )

            dailyForecastItems.append(forecastItem)
        }

        return dailyForecastItems
    }
}
