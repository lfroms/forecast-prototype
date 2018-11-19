//
//  GlobalExtensions.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-11-18.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation

extension Float {
    func asRoundedString() -> String {
        return String(format: "%.0f", self.rounded())
    }
}
