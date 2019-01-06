//
//  DateTime.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-16.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import SWXMLHash

struct DateTime: XMLIndexerDeserializable {
    struct DateTimeValue: XMLIndexerDeserializable {
        struct Day: XMLIndexerDeserializable {
            let name: String
            let value: String
            
            static func deserialize(_ node: XMLIndexer) throws -> Day {
                return try Day(
                    name: node.value(ofAttribute: "name"),
                    value: node.value()
                )
            }
        }
        
        struct Month: XMLIndexerDeserializable {
            let name: String
            let value: String
            
            static func deserialize(_ node: XMLIndexer) throws -> Month {
                return try Month(
                    name: node.value(ofAttribute: "name"),
                    value: node.value()
                )
            }
        }
        
        let year: String?
        let month: Month?
        let day: Day?
        let timeStamp: String?
        let textSummary: String?
        
        static func deserialize(_ node: XMLIndexer) throws -> DateTimeValue {
            return try DateTimeValue(
                year: node["year"].value(),
                month: node["month"].value(),
                day: node["day"].value(),
                timeStamp: node["timeStamp"].value(),
                textSummary: node["textSummary"].value()
            )
        }
    }
    
    let name: String
    let zone: String
    let UTCOffset: String
    let value: DateTimeValue?
    
    static func deserialize(_ node: XMLIndexer) throws -> DateTime {
        return try DateTime(
            name: node.value(ofAttribute: "name"),
            zone: node.value(ofAttribute: "zone"),
            UTCOffset: node.value(ofAttribute: "UTCOffset"),
            value: node.value()
        )
    }
}
