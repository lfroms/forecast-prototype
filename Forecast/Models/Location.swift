//
//  Location.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-16.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import SWXMLHash

struct LocationPoint: XMLIndexerDeserializable {
    let code: String
    let lat: String?
    let lon: String?
    let value: String
    
    static func deserialize(_ node: XMLIndexer) throws -> LocationPoint {
        return try LocationPoint(
            code: node.value(ofAttribute: "code"),
            lat: node.value(ofAttribute: "lat"),
            lon: node.value(ofAttribute: "lon"),
            value: node.value()
        )
    }
}

struct Location: XMLIndexerDeserializable {
    let continent: String
    let country: LocationPoint
    let province: LocationPoint
    let name: LocationPoint
    let region: String
    
    static func deserialize(_ node: XMLIndexer) throws -> Location {
        return try Location(
            continent: node["continent"].value(),
            country: node["country"].value(),
            province: node["province"].value(),
            name: node["name"].value(),
            region: node["region"].value()
        )
    }
}

