//
//  Float+RoundedString.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-30.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation

extension Float {
    func asRoundedString() -> String {
        // Add 0.0 to address -0 issue.
        return String(format: "%.0f", self.rounded() + 0.0)
    }

    func toString() -> String {
        return String(self)
    }
}
