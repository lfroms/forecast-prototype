//
//  RenderYesterdayConditions.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-10.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation

extension MainViewController {
    func renderYesterdayConditions(_ data: WeatherQuery.Data.Weather) {
        let yc = data.yesterdayConditions

        var yesterdayConditionItems: [IconDetailItem] = []

        if let high = yc.temperature.first(where: { $0.class == "high" }) {
            let temperature = Temperature.toPreferredUnit(high.value)
            let item = IconDetailItem(icon: "arrow-up", detail: temperature + "°")

            yesterdayConditionItems.append(item)
        }

        if let low = yc.temperature.first(where: { $0.class == "low" }) {
            let temperature = Temperature.toPreferredUnit(low.value)
            let item = IconDetailItem(icon: "arrow-down", detail: temperature + "°")

            yesterdayConditionItems.append(item)
        }

        if let precip = yc.precip.first, let value = precip.value {
            let precipFormatted = Float(value) != nil ? value + precip.units : value
            let item = IconDetailItem(icon: "tint", detail: precipFormatted)

            yesterdayConditionItems.append(item)
        }

        yesterdayIconDetailView.dataSourceItems = yesterdayConditionItems
        yesterdayContainerView.isHidden = yesterdayConditionItems.isEmpty
    }
}
