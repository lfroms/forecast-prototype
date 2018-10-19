//
//  Measurement.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-16.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import SWXMLHash

struct Measurement: XMLIndexerDeserializable {
    let unitType: String?
    let units: String?
    let value: String
    let uClass: String?

    static func deserialize(_ node: XMLIndexer) throws -> Measurement {
        return try Measurement(
            unitType: node.value(ofAttribute: "unitType"),
            units: node.value(ofAttribute: "units"),
            value: node.value(),
            uClass: node.value(ofAttribute: "class")
        )
    }
}
