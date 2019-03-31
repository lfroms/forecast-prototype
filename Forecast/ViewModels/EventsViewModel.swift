//
//  EventsViewModel.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-11-26.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation

struct EventsViewModel {
    private let events: [WeatherQuery.Data.Weather.Warning.Event]?
    private let url: String?
    
    init(_ events: [WeatherQuery.Data.Weather.Warning.Event]?, url: String?) {
        self.events = events
        self.url = url
    }
    
    var items: [WarningItem] {
        var warningItems: [WarningItem] = []
        
        events?.forEach(
            { event in
                let timestamp = event.dateTime?.timeStamp?
                    .toDate("yyyyMMddhhmmss", region: .UTC)?
                    .convertTo(region: .current)
                    .toFormat("MMM d h:mm a")
                
                let warningURL: URL? = {
                    guard let url = self.url else {
                        return nil
                    }
                    
                    return URL(string: url)
                }()
                
                let item = WarningItem(
                    title: event.description,
                    description: timestamp,
                    priority: event.priority,
                    type: event.type,
                    url: warningURL
                )
                
                warningItems.append(item)
            }
        )
        
        return warningItems
    }
}
