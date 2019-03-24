//
//  Temperature.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-24.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation

class Temperature {
    static func toPrefferedUnit(_ value: Float) -> Float {
        if UserPreferences.preferredTemperature() == .f {
            let fahrenheit = value * 9 / 5 + 32
            return round(fahrenheit * 10) / 10
        }

        return value
    }
    
    static func toPreferredUnit(_ value: String?, round: Bool = false) -> String {
        guard value != nil else {
            return ""
        }
        
        if let asFloat = Float(value!) {
            let asPreferredUnit = toPrefferedUnit(asFloat)
            return round ? asPreferredUnit.asRoundedString() : asPreferredUnit.toString()
        }
        
        return value!
    }

    static func currentUnit(symbol: Bool = false) -> String {
        return (symbol ? "°" : "") + UserPreferences.preferredTemperature().rawValue
    }
}
