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
        sunriseSunsetStack.subviews.forEach({ $0.removeFromSuperview() })
        
        data.riseSet.dateTime?.forEach(
            { item in
                let time = item.timeStamp?
                    .toDate("yyyyMMddHHmmss", region: .UTC)?
                    .convertTo(region: .current)
                    .toFormat("H:mm z", locale: Locales.current)
                
                let subview = ConditionView().with(
                    value: time,
                    units: nil,
                    type: item.name.uppercased(),
                    icon: item.name == "sunrise" ? "sun" : "moon"
                )
                
                sunriseSunsetStack.addArrangedSubview(subview)
            }
        )
    }
}
