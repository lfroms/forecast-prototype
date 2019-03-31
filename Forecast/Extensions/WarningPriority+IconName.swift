//
//  WarningPriority+IconName.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-30.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation

extension WarningPriority {
    private static let defaultIconName = "info-circle"

    private static let iconNames: [WarningPriority: String] = [
        .low: defaultIconName,
        .medium: "exclamation-circle",
        .high: "exclamation-triangle"
    ]

    var iconName: String {
        return WarningPriority.iconNames[self, default: WarningPriority.defaultIconName]
    }
}
