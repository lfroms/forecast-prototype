//
//  RenderSunriseSunset.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-12-23.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation
import SwiftDate

extension MainViewController {
    func renderSunriseSunset(_ data: WeatherQuery.Data.Weather) {
        var sunriseSunsetItems: [ObservationItem] = []
        
        data.riseSet.dateTime?.forEach(
            { item in
                let time = item.timeStamp?
                    .toDate("yyyyMMddHHmmss", region: .UTC)?
                    .convertTo(region: .current)
                    .toFormat("H:mm z", locale: Locales.current) ?? ""
                
                let observationItem = ObservationItem(
                    icon: item.name == "sunrise" ? "sun" : "moon",
                    value: time,
                    units: nil,
                    description: item.name,
                    prefix: nil
                )
                
                sunriseSunsetItems.append(observationItem)
            }
        )
        
        sunriseSunsetView.dataSourceItems = sunriseSunsetItems
    }
}
