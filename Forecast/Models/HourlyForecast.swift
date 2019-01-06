//
//  HourlyForecast.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-12-23.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import SWXMLHash

struct HourlyForecast: XMLIndexerDeserializable {
    struct HourlyWind: XMLIndexerDeserializable {
        let speed: Measurement
        let gust: Measurement

        static func deserialize(_ node: XMLIndexer) throws -> HourlyWind {
            return try HourlyWind(
                speed: node["speed"].value(),
                gust: node["gust"].value()
            )
        }
    }

    let dateTimeUTC: String
    let condition: String
    let iconCode: String
    let temperature: Measurement
    let pop: Measurement
    let windChill: Measurement
    let humidex: Measurement
    let wind: HourlyWind

    static func deserialize(_ node: XMLIndexer) throws -> HourlyForecast {
        return try HourlyForecast(
            dateTimeUTC: node.value(ofAttribute: "dateTimeUTC"),
            condition: node["condition"].value(),
            iconCode: node["iconCode"].value(),
            temperature: node["temperature"].value(),
            pop: node["lop"].value(),
            windChill: node["windChill"].value(),
            humidex: node["humidex"].value(),
            wind: node["wind"].value()
        )
    }
}
