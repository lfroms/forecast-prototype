//
//  WarningPriority+Color.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-30.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation
import UIKit

extension WarningPriority {
    private var defaultColor: UIColor {
        return UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 1.0)
    }

    private var colors: [WarningPriority: UIColor] {
        return [
            .low: defaultColor,
            .medium: UIColor(red: 1.00, green: 0.92, blue: 0.00, alpha: 1.0),
            .high: UIColor(red: 0.96, green: 0.26, blue: 0.21, alpha: 1.0),
        ]
    }

    var color: UIColor {
        return colors[self, default: defaultColor]
    }
}
