//
//  Forecast.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-16.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import SWXMLHash

struct Forecast: XMLIndexerDeserializable {
    struct Period: XMLIndexerDeserializable {
        let textForecastName: String
        let value: String
        
        static func deserialize(_ node: XMLIndexer) throws -> Period {
            return try Period(
                textForecastName: node.value(ofAttribute: "textForecastName"),
                value: node.value()
            )
        }
    }
    
    struct CloudPrecip: XMLIndexerDeserializable {
        let textSummary: String?
        
        static func deserialize(_ node: XMLIndexer) throws -> CloudPrecip {
            return try CloudPrecip(textSummary: node["textSummary"].value())
        }
    }
    
    struct AbbreviatedForecast: XMLIndexerDeserializable {
        let iconCode: String
        let pop: Measurement
        let textSummary: String?
        
        static func deserialize(_ node: XMLIndexer) throws -> AbbreviatedForecast {
            return try AbbreviatedForecast(
                iconCode: node["iconCode"].value(),
                pop: node["pop"].value(),
                textSummary: node["textSummary"].value()
            )
        }
    }
    
    let period: Period
    let textSummary: String?
    let cloudPrecip: CloudPrecip
    let abbreviatedForecast: AbbreviatedForecast
    let temperatures: [Measurement]
    let winds: [Wind]?
    let relativeHumidity: Measurement?
    
    static func deserialize(_ node: XMLIndexer) throws -> Forecast {
        return try Forecast(
            period: node["period"].value(),
            textSummary: node["textSummary"].value(),
            cloudPrecip: node["cloudPrecip"].value(),
            abbreviatedForecast: node["abbreviatedForecast"].value(),
            temperatures: node["temperatures"]["temperature"].value(),
            winds: node["winds"]["wind"].value(),
            relativeHumidity: node["relativeHumidity"].value()
        )
    }
}
