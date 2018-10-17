//
//  CurrentConditions.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-16.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import SWXMLHash

struct CurrentConditions: XMLIndexerDeserializable {
    let station: LocationPoint
    let dateTime: [DateTime]
    let condition: String
    let iconCode: String
    let temperature: Measurement
    let dewpoint: Measurement
    let pressure: Pressure
    let visibility: Measurement
    let relativeHumidity: Measurement
    let wind: Wind
    
    
    static func deserialize(_ node: XMLIndexer) throws -> CurrentConditions {
        return try CurrentConditions(
            station: node["station"].value(),
            dateTime: node["dateTime"].value(),
            condition: node["condition"].value(),
            iconCode: node["iconCode"].value(),
            temperature: node["temperature"].value(),
            dewpoint: node["dewpoint"].value(),
            pressure: node["pressure"].value(),
            visibility: node["visibility"].value(),
            relativeHumidity: node["relativeHumidity"].value(),
            wind: node["wind"].value()
        )
    }
}
