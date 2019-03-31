//
//  RegionalNormalsViewModel.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-10.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation

struct RegionalNormalsViewModel {
    private let regionalNormals: WeatherQuery.Data.Weather.ForecastGroup.RegionalNormal
    
    init(_ regionalNormals: WeatherQuery.Data.Weather.ForecastGroup.RegionalNormal) {
        self.regionalNormals = regionalNormals
    }
    
    var items: [IconDetailItem] {
        var regionalNormalsItems: [IconDetailItem] = []
        
        if let high = regionalNormals.temperature.first(where: { $0.class == "high" }) {
            let temperature = Temperature.toPreferredUnit(high.value, round: true)
            let item = IconDetailItem(icon: "arrow-up", detail: temperature + "°")
            
            regionalNormalsItems.append(item)
        }
        
        if let low = regionalNormals.temperature.first(where: { $0.class == "low" }) {
            let temperature = Temperature.toPreferredUnit(low.value, round: true)
            let item = IconDetailItem(icon: "arrow-down", detail: temperature + "°")
            
            regionalNormalsItems.append(item)
        }
        
        return regionalNormalsItems
    }
}
