//
//  RegionalNormals.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-19.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import SWXMLHash

struct RegionalNormals: XMLIndexerDeserializable {
    let textSummary: String?
    let temperature: [Measurement]?

    static func deserialize(_ node: XMLIndexer) throws -> RegionalNormals {
        return try RegionalNormals(
            textSummary: node["textSummary"].value(),
            temperature: node["temperature"].value()
        )
    }
}
