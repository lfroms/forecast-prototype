//
//  RenderRegionalNormals.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-10.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation

extension MainViewController {
    func renderRegionalNormals(_ data: WeatherQuery.Data.Weather) {
        let rn = data.forecastGroup.regionalNormals
        
        var regionalNormalsItems: [IconDetailItem] = []
        
        if let high = rn.temperature.first(where: { $0.class == "high" }) {
            let temperature = Temperature.toPreferredUnit(high.value)
            let item = IconDetailItem(icon: "arrow-up", detail: temperature + "°")
            
            regionalNormalsItems.append(item)
        }
        
        if let low = rn.temperature.first(where: { $0.class == "low" }) {
            let temperature = Temperature.toPreferredUnit(low.value)
            let item = IconDetailItem(icon: "arrow-down", detail: temperature + "°")
            
            regionalNormalsItems.append(item)
        }
        
        regionalNormalsIconDetailView.dataSourceItems = regionalNormalsItems
        regionalNormalsContainerView.isHidden = regionalNormalsItems.isEmpty
    }
}
