//
//  ForecastIconMap.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-12-24.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation

func textForIconCode(_ code: String) -> String {
    guard let icon = Int(code) else {
        return ""
    }
    
    var outChar: Int
    
    switch icon {
    case 0:
        outChar = 0xf4b7
    case 1:
        outChar = 0xf4b7
    case 2:
        outChar = 0xf1df
    case 3:
        outChar = 0xf1df
    case 4:
        outChar = 0xf1df
    case 5:
        outChar = 0xf4b7
    case 6:
        outChar = 0xf495
    case 7:
        outChar = 0xf495
    case 8:
        outChar = 0xf495
    case 9:
        outChar = 0xf4bd
    case 10:
        outChar = 0xf410
    case 12:
        outChar = 0xf495
    case 13:
        outChar = 0xf495
    case 14:
        outChar = 0xf495
    case 15:
        outChar = 0xf495
    case 16:
        outChar = 0xf218
    case 17:
        outChar = 0xf218
    case 18:
        outChar = 0xf218
    case 19:
        outChar = 0xf218
    case 22:
        outChar = 0xf1df
    case 23:
        outChar = 0xf410
    case 24:
        outChar = 0xf410
    case 27:
        outChar = 0xf495
    case 28:
        outChar = 0xf495
    case 29:
        outChar = 0xf4b7
    case 30:
        outChar = 0xf468
    case 31:
        outChar = 0xf40e
    case 32:
        outChar = 0xf40e
    case 33:
        outChar = 0xf410
    case 34:
        outChar = 0xf410
    case 35:
        outChar = 0xf468
    case 36:
        outChar = 0xf495
    case 37:
        outChar = 0xf495
    case 38:
        outChar = 0xf218
    case 39:
        outChar = 0xf4bd
    case 40:
        outChar = 0xf218
    case 43:
        outChar = 0xf410
    case 44:
        outChar = 0xf24f
    default:
        outChar = 0xf4b7
    }
    
    let scalar = UnicodeScalar(outChar)!
    return "\(scalar)"
}
