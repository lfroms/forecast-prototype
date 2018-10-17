//
//  Wind.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-16.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import SWXMLHash

struct Wind: XMLIndexerDeserializable {
    let speed: Measurement
    let gust: Measurement
    let direction: Measurement
    let bearing: Measurement
    
    static func deserialize(_ node: XMLIndexer) throws -> Wind {
        return try Wind(
            speed: node["speed"].value(),
            gust: node["gust"].value(),
            direction: node["direction"].value(),
            bearing: node["bearing"].value()
        )
    }
}
