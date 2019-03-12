//
//  ForecastIconMap.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-12-24.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation

private enum ForecastIcon: Int {
    case sunny = 0xf4b7
    case partlySunny = 0xf1df
    case rainy = 0xf495
    case thunderstorm = 0xf4bd
    case cloudy = 0xf410
    case snow = 0xf218
    case moon = 0xf468
    case cloudyNight = 0xf40e
}

func textForIconCode(_ code: String) -> String {
    guard let codeInt = Int(code) else {
        return ""
    }

    let scalar = UnicodeScalar(iconFor(codeInt).rawValue)!
    return "\(scalar)"
}

private func iconFor(_ value: Int) -> ForecastIcon {
    switch value {
    case 0:
        return .sunny
    case 1:
        return .sunny
    case 2:
        return .partlySunny
    case 3:
        return .partlySunny
    case 4:
        return .partlySunny
    case 5:
        return .sunny
    case 6:
        return .rainy
    case 7:
        return .rainy
    case 8:
        return .rainy
    case 9:
        return .thunderstorm
    case 10:
        return .cloudy
    case 12:
        return .rainy
    case 13:
        return .rainy
    case 14:
        return .rainy
    case 15:
        return .rainy
    case 16:
        return .snow
    case 17:
        return .snow
    case 18:
        return .snow
    case 19:
        return .snow
    case 22:
        return .partlySunny
    case 23:
        return .cloudy
    case 24:
        return .cloudy
    case 27:
        return .rainy
    case 28:
        return .rainy
    case 29:
        return .sunny
    case 30:
        return .moon
    case 31:
        return .cloudyNight
    case 32:
        return .cloudyNight
    case 33:
        return .cloudy
    case 34:
        return .cloudy
    case 35:
        return .moon
    case 36:
        return .rainy
    case 37:
        return .rainy
    case 38:
        return .snow
    case 39:
        return .thunderstorm
    case 40:
        return .snow
    case 43:
        return .cloudy
    case 44:
        return .cloudy
    default:
        return .sunny
    }
}
