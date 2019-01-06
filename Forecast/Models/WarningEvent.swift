//
//  WarningEvent.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-11-26.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import SWXMLHash

enum WarningPriority: String {
    case low
    case medium
    case high
    case urgent
}

enum WarningType: String {
    case statement
    case watch
    case warning
    case ended
    case advistory
}

struct WarningEvent: XMLIndexerDeserializable {
    let type: WarningType
    let priority: WarningPriority
    let description: String
    let dateTime: [DateTime]

    static func deserialize(_ node: XMLIndexer) throws -> WarningEvent {
        return try WarningEvent(
            type: WarningType(rawValue: node.value(ofAttribute: "type")) ?? .statement,
            priority: WarningPriority(rawValue: node.value(ofAttribute: "priority")) ?? .low,
            description: node.value(ofAttribute: "description"),
            dateTime: node["dateTime"].value()
        )
    }
}
