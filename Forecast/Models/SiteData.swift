//
//  SiteData.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-16.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import SWXMLHash

struct SiteData: XMLIndexerDeserializable {
    let location: Location
    let currentConditions: CurrentConditions
    
    
    static func deserialize(_ node: XMLIndexer) throws -> SiteData {
        return try SiteData(
            location: node["location"].value(),
            currentConditions: node["currentConditions"].value()
        )
    }
}
