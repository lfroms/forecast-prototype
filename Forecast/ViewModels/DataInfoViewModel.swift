//
//  DataInfoViewModel.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-31.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation
import SwiftDate

typealias CurrentCondition = WeatherQuery.Data.Weather.CurrentCondition
typealias ForecastGroup = WeatherQuery.Data.Weather.ForecastGroup

struct DataInfoViewModel {
    private let currentConditions: CurrentCondition
    private let forecastGroup: ForecastGroup

    init(currentConditions: CurrentCondition, forecastGroup: ForecastGroup) {
        self.currentConditions = currentConditions
        self.forecastGroup = forecastGroup
    }

    var data: DataInfoData {
        let date =
            forecastGroup.dateTime?.timeStamp?
            .toDate("yyyyMMddHHmmss", region: .UTC)?
            .convertTo(region: .current)
            .toFormat("MMM d 'at' h:mm a", locale: Locales.current)

        let location = currentConditions.station?.value

        return DataInfoData(locationName: location, forecastIssueDate: date)
    }
}
