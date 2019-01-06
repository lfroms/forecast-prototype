//
//  ForecastGroup.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-16.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import SWXMLHash

struct ForecastGroup: XMLIndexerDeserializable {
    let dateTime: [DateTime]
    let regionalNormals: RegionalNormals
    let forecast: [Forecast]?

    static func deserialize(_ node: XMLIndexer) throws -> ForecastGroup {
        return try ForecastGroup(
            dateTime: node["dateTime"].value(),
            regionalNormals: node["regionalNormals"].value(),
            forecast: node["forecast"].value()
        )
    }
}
