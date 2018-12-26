//
//  GlobalExtensions.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-11-18.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation
import UIKit

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

extension UIImage {
    func aspectFitImage(inRect rect: CGRect) -> UIImage? {
        let width = self.size.width
        let height = self.size.height
        let scaleFactor = width > height ? rect.size.height / height : rect.size.width / width

        UIGraphicsBeginImageContextWithOptions(CGSize(width: width * scaleFactor, height: height * scaleFactor), false, 0.0)
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: width * scaleFactor, height: height * scaleFactor))

        defer {
            UIGraphicsEndImageContext()
        }

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
