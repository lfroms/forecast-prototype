//
//  AlertsViewController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-11-26.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Siesta
import UIKit

extension MainViewController {
    func renderWarnings(_ data: SiteData) {
        warningsStack.subviews.forEach({ $0.removeFromSuperview() })

        data.warnings.events?.forEach(
            { event in
                let timestamp = event.dateTime[1].value?.timeStamp?.toDate("yyyyMMddhhmmss")?
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
            headerBlur.backgroundColor = getColorForAlertPriority(data.warnings.events?.first?.priority)
            return
        }
        
        headerBlur.backgroundColor = .clear
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
