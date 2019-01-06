//
//  Warnings.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-11-26.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import SWXMLHash

struct Warnings: XMLIndexerDeserializable {
    let events: [WarningEvent]?
    let url: String?

    static func deserialize(_ node: XMLIndexer) throws -> Warnings {
        return try Warnings(
            events: node["event"].value(),
            url: node.value(ofAttribute: "url")
        )
    }
}
