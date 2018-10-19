//
//  Location.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-16.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import SWXMLHash

struct Location: XMLIndexerDeserializable {
    let continent: String
    let country: ExactLocation
    let province: ExactLocation
    let name: ExactLocation
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
