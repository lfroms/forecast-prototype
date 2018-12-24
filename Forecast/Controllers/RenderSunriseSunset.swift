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
    func renderSunriseSunset(_ data: SiteData) {
        sunriseSunsetStack.subviews.forEach({ $0.removeFromSuperview() })
        
        data.riseSet.dateTime?.filter({ $0.zone == "UTC" }).forEach(
            { item in
                let time = item.value.timeStamp
                    .toDate("yyyyMMddHHmmss", region: .UTC)?
                    .convertTo(region: .current)
                    .toFormat("H:mm z", locale: Locales.current)
                
                let subview = ConditionView().with(
                    aux: nil,
                    value: time,
                    units: nil,
                    type: item.name.uppercased(),
                    icon: "sun"
                )
                
                sunriseSunsetStack.addArrangedSubview(subview)
            }
        )
    }
}
