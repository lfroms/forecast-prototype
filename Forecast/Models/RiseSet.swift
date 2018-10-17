//
//  RiseSet.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-16.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import SWXMLHash

struct RiseSet: XMLIndexerDeserializable {
    let dateTime: [DateTime]?
    
    static func deserialize(_ node: XMLIndexer) throws -> RiseSet {
        return try RiseSet(
            dateTime: node["dateTime"].value()
        )
    }
}
