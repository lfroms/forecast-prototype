//
//  AlertsViewController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-11-26.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import UIKit

extension MainViewController {
    func renderWarnings(_ data: WeatherQuery.Data.Weather) {
        warningsStack.subviews.forEach({ $0.removeFromSuperview() })

        guard let events = data.warnings.events else {
            headerBlur.backgroundColor = .clear
            return
        }

        events.forEach(
            { event in
                let timestamp = event.dateTime?.timeStamp?.toDate("yyyyMMddhhmmss")?
                    .toFormat("MMM d h:mm a")

                let subview = AlertItem().with(
                    icon: iconForAlertPriority(event.priority),
                    title: event.description,
                    description: timestamp,
                    priority: event.priority,
                    url: data.warnings.url
                )

                warningsStack.addArrangedSubview(subview)
            }
        )

        if !warningsStack.arrangedSubviews.isEmpty {
            if let priorityAsType = events.first?.priority {
                headerBlur.backgroundColor = getColorForAlertPriority(priorityAsType)
            }
        }
    }

    private func iconForAlertPriority(_ priority: WarningPriority?) -> String {
        switch priority {
        case .low?:
            return "info-circle"
        case .medium?:
            return "exclamation-circle"
        case .high?:
            return "exclamation-triangle"
        default:
            return "info-circle"
        }
    }
}
