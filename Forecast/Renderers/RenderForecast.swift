//
//  RenderForecast.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-12-23.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation

extension MainViewController {
    func renderForecast(_ data: WeatherQuery.Data.Weather) {
        noDailyForecastLabel.isHidden = true
        forecastStack.subviews.forEach({ $0.removeFromSuperview() })

        guard data.forecastGroup.forecast.count > 0 else {
            self.noDailyForecastLabel.isHidden = false
            return
        }

        data.forecastGroup.forecast.forEach(
            { item in
                let subview = ForecastItem().with(
                    icon: ForecastIcon.forCode(item.abbreviatedForecast.iconCode?.value ?? "00"),
                    day: item.period.textForecastName,
                    temperature: item.temperatures.temperature.first?.value,
                    units: "°" + (item.temperatures.temperature.first?.units ?? ""),
                    description: item.abbreviatedForecast.textSummary,
                    pop: item.abbreviatedForecast.pop?.value
                )

                forecastStack.addArrangedSubview(subview)
            }
        )
    }
}
