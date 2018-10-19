//
//  ExactLocation.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-19.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import SWXMLHash

struct ExactLocation: XMLIndexerDeserializable {
    let code: String
    let lat: String?
    let lon: String?
    let value: String

    static func deserialize(_ node: XMLIndexer) throws -> ExactLocation {
        return try ExactLocation(
            code: node.value(ofAttribute: "code"),
            lat: node.value(ofAttribute: "lat"),
            lon: node.value(ofAttribute: "lon"),
            value: node.value()
        )
    }
}
