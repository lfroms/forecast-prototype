//
//  WarningEvent.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-11-26.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import SWXMLHash

enum AlertPriority: String {
    case low
    case medium
    case high
    case urgent
}

enum AlertType: String {
    case statement
    case watch
    case warning
}

struct WarningEvent: XMLIndexerDeserializable {
    let type: AlertType?
    let priority: AlertPriority?
    let description: String?
    let dateTime: [DateTime]?

    static func deserialize(_ node: XMLIndexer) throws -> WarningEvent {
        return try WarningEvent(
            type: AlertType(rawValue: node.value(ofAttribute: "type")),
            priority: AlertPriority(rawValue: node.value(ofAttribute: "priority")),
            description: node.value(ofAttribute: "description"),
            dateTime: node["dateTime"].value()
        )
    }
}
