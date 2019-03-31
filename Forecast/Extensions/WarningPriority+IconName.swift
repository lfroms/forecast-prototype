//
//  WarningPriority+IconName.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-30.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation

extension WarningPriority {
    private var defaultIconName: String {
        return "info-circle"
    }

    private var iconNames: [WarningPriority: String] {
        return [
            .low: defaultIconName,
            .medium: "exclamation-circle",
            .high: "exclamation-triangle"
        ]
    }

    var iconName: String {
        return iconNames[self, default: defaultIconName]
    }
}
