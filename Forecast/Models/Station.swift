//
//  Station.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-16.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import SWXMLHash

struct Station: XMLIndexerDeserializable {
    let code: String
    let lat: String
    let lon: String
    let value: String
    
    static func deserialize(_ node: XMLIndexer) throws -> Station {
        return try Station(
            code: node.value(ofAttribute: "code"),
            lat: node.value(ofAttribute: "lat"),
            lon: node.value(ofAttribute: "lon"),
            value: node.value()
        )
    }
}
