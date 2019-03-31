//
//  YesterdayConditionViewModel.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-10.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation

struct YesterdayConditionViewModel {
    private let yesterdayCondition: WeatherQuery.Data.Weather.YesterdayCondition

    init(_ yesterdayCondition: WeatherQuery.Data.Weather.YesterdayCondition) {
        self.yesterdayCondition = yesterdayCondition
    }

    var items: [IconDetailItem] {
        var yesterdayConditionItems: [IconDetailItem] = []

        if let high = yesterdayCondition.temperature.first(where: { $0.class == "high" }) {
            let temperature = Temperature.toPreferredUnit(high.value)
            let item = IconDetailItem(icon: "arrow-up", detail: temperature + "°")

            yesterdayConditionItems.append(item)
        }

        if let low = yesterdayCondition.temperature.first(where: { $0.class == "low" }) {
            let temperature = Temperature.toPreferredUnit(low.value)
            let item = IconDetailItem(icon: "arrow-down", detail: temperature + "°")

            yesterdayConditionItems.append(item)
        }

        if let precip = yesterdayCondition.precip.first, let value = precip.value {
            let precipFormatted = Float(value) != nil ? value + precip.units : value
            let item = IconDetailItem(icon: "tint", detail: precipFormatted)

            yesterdayConditionItems.append(item)
        }

        return yesterdayConditionItems
    }
}
