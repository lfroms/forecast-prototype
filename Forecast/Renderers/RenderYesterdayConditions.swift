//
//  RenderYesterdayConditions.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-10.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

extension MainViewController {
    func renderYesterdayConditions(_ data: WeatherQuery.Data.Weather) {
        self.yesterdayConditionsContainer.isHidden = false
        let yc = data.yesterdayConditions

        let high = yc.temperature.first(where: { $0.class == "high" })
        let low = yc.temperature.first(where: { $0.class == "low" })
        let precip = yc.precip.first

        guard
            high != nil,
            low != nil,
            precip != nil,
            precip?.value != nil,
            high?.value != nil,
            low?.value != nil
        else {
            self.yesterdayConditionsContainer.isHidden = true
            return
        }

        self.yesterdayHighLabel.text = Temperature.toPreferredUnit(high!.value!) + "°"
        self.yesterdayLowLabel.text = Temperature.toPreferredUnit(low!.value!) + "°"
        self.yesterdayPrecipLabel.text = precip!.value! + precip!.units
    }
}
