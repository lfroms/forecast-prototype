//
//  EnvCanada.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-22.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation

class EnvCanada {
    static let shared = WeatherService()
    private init() {}
}
