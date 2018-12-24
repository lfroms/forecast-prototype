//
//  RenderHourlyForecast.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-12-23.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation
import SwiftDate

extension MainViewController {
    func renderHourlyForecast(_ data: SiteData) {
        hourlyForecastStack.subviews.forEach({ $0.removeFromSuperview() })
        
        data.hourlyForecastGroup.hourlyForecast.forEach(
            { item in
                let hour = item.dateTimeUTC
                    .toDate("yyyyMMddHHmm", region: .UTC)?
                    .convertTo(region: .current)
                    .toFormat("h")
                
                let amPm = item.dateTimeUTC
                    .toDate("yyyyMMddHHmm", region: .UTC)?
                    .convertTo(region: .current)
                    .toFormat("a")
                
                let temperatureUnits = ["°", item.temperature.units]
                    .compactMap { $0 }
                    .joined()
                
                var windSpeed: String?
                
                // Check if this is actually a number. Sometimes, it can be a string,
                // in which case we don't want to show the units.
                if let _ = Int(item.wind?.speed.value ?? "") {
                    windSpeed = [item.wind?.speed.value, item.wind?.speed.units]
                        .compactMap { $0 }
                        .joined(separator: " ")
                } else {
                    windSpeed = item.wind?.speed.value
                }
                
                let subview = HourlyItem().with(
                    hour: hour ?? "",
                    amPm: amPm ?? "",
                    icon: item.iconCode,
                    temperature: item.temperature.value,
                    temperatureUnits: temperatureUnits,
                    windSpeed: windSpeed,
                    pop: item.pop.value
                )
                
                hourlyForecastStack.addArrangedSubview(subview)
            }
        )
    }
}
