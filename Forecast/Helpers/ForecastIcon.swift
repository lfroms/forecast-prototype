//
//  ForecastIcon.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-12-24.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation

class ForecastIcon {
    private enum AvailableIcon: Int {
        case sunny = 0xf4b7
        case partlySunny = 0xf1df
        case rainy = 0xf495
        case thunderstorm = 0xf4bd
        case cloudy = 0xf410
        case snow = 0xf218
        case moon = 0xf468
        case cloudyNight = 0xf40e
    }

    static func forCode(_ code: String) -> String {
        guard let codeInt = Int(code), let iconString = icon[codeInt]?.rawValue else {
            return ""
        }

        let scalar = UnicodeScalar(iconString)!
        return "\(scalar)"
    }

    private static let icon: [Int: AvailableIcon] = [
        0: .sunny,
        1: .sunny,
        2: .partlySunny,
        3: .partlySunny,
        4: .partlySunny,
        5: .sunny,
        6: .rainy,
        7: .rainy,
        8: .rainy,
        9: .thunderstorm,
        10: .cloudy,
        12: .rainy,
        13: .rainy,
        14: .rainy,
        15: .rainy,
        16: .snow,
        17: .snow,
        18: .snow,
        19: .snow,
        22: .partlySunny,
        23: .cloudy,
        24: .cloudy,
        27: .rainy,
        28: .rainy,
        29: .sunny,
        30: .moon,
        31: .cloudyNight,
        32: .cloudyNight,
        33: .cloudy,
        34: .cloudy,
        35: .moon,
        36: .rainy,
        37: .rainy,
        38: .snow,
        43: .cloudy,
        44: .cloudy
    ]
}
