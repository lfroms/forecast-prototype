//
//  RenderForecast.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-12-23.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation

extension MainViewController {
    func renderForecast(_ data: SiteData) {
        noDailyForecastLabel.isHidden = true
        forecastStack.subviews.forEach({ $0.removeFromSuperview() })

        guard data.forecastGroup.forecast != nil else {
            self.noDailyForecastLabel.isHidden = false
            return
        }

        data.forecastGroup.forecast?.forEach(
            { item in
                let subview = ForecastItem().with(
                    icon: textForIconCode(item.abbreviatedForecast.iconCode),
                    day: item.period.textForecastName,
                    temperature: item.temperatures.first?.value,
                    units: "°" + (item.temperatures.first?.units ?? ""),
                    description: item.abbreviatedForecast.textSummary,
                    pop: item.abbreviatedForecast.pop.value
                )

                forecastStack.addArrangedSubview(subview)
            }
        )
    }
}
