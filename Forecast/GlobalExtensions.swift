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

extension String {
    func hasWhiteSpace() -> Bool {
        let charset = CharacterSet(charactersIn: " ")
        return self.lowercased().rangeOfCharacter(from: charset) != nil
    }
}
