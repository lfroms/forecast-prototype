//
//  RenderWarnings.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-11-26.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import UIKit

extension MainViewController {
    func renderWarnings(_ data: WeatherQuery.Data.Weather) {
        let events = data.warnings.events
        
        var warningItems: [WarningItem] = []
        
        events?.forEach(
            { event in
                let timestamp = event.dateTime?.timeStamp?
                    .toDate("yyyyMMddhhmmss", region: .UTC)?
                    .convertTo(region: .current)
                    .toFormat("MMM d h:mm a")
                
                let url: URL? = {
                    guard let url = data.warnings.url else {
                        return nil
                    }
                    
                    return URL(string: url)
                }()
                
                let item = WarningItem(
                    title: event.description,
                    description: timestamp,
                    priority: event.priority,
                    type: event.type,
                    url: url
                )
                
                warningItems.append(item)
            }
        )
        
        headerView.warnings = warningItems
    }
}
