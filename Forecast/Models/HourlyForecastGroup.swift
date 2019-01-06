//
//  HourlyForecastGroup.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-12-23.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import SWXMLHash

struct HourlyForecastGroup: XMLIndexerDeserializable {
    let dateTime: [DateTime]?
    let hourlyForecast: [HourlyForecast]?

    static func deserialize(_ node: XMLIndexer) throws -> HourlyForecastGroup {
        return try HourlyForecastGroup(
            dateTime: node["dateTime"].value(),
            hourlyForecast: node["hourlyForecast"].value()
        )
    }
}
