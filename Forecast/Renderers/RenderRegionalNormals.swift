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
        self.regionalNormalsContainer.isHidden = false
        let rn = data.forecastGroup.regionalNormals
        
        let high = rn.temperature.first(where: { $0.class == "high" })
        let low = rn.temperature.first(where: { $0.class == "low" })
        
        guard
            high != nil,
            low != nil,
            high?.value != nil,
            low?.value != nil
        else {
            self.regionalNormalsContainer.isHidden = true
            return
        }
        
        self.normalHighLabel.text = high!.value! + "°"
        self.normalLowLabel.text = low!.value! + "°"
    }
}
