//
//  Pressure.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-16.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import SWXMLHash

struct Pressure: XMLIndexerDeserializable {
    let unitType: String
    let units: String
    let change: String
    let tendency: String
    let value: String

    static func deserialize(_ node: XMLIndexer) throws -> Pressure {
        return try Pressure(
            unitType: node.value(ofAttribute: "unitType"),
            units: node.value(ofAttribute: "units"),
            change: node.value(ofAttribute: "change"),
            tendency: node.value(ofAttribute: "tendency"),
            value: node.value()
        )
    }
}
