//
//  DoubleStackView.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-12-24.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import UIKit

class DoubleStackView: UIStackView {
    private var lastAddedSubviewIndex: Int = 0
    public func addOrganizedSubview(_ view: UIView) throws {
        if let stack = subviews[lastAddedSubviewIndex] as? UIStackView {
            stack.addArrangedSubview(view)
            if lastAddedSubviewIndex == subviews.count - 1 {
                lastAddedSubviewIndex = 0
            } else {
                lastAddedSubviewIndex += 1
            }
        } else {
            throw "Cannot perform stack operation on non UIStackView child"
        }
    }
    
    public func removeAllSubviews() {
        subviews.forEach { view in
            view.subviews.forEach({ $0.removeFromSuperview() })
        }
        
        lastAddedSubviewIndex = 0
    }
    
    public func hasAnyItems() -> Bool {
        var counter: Int = 0
        
        subviews.forEach { view in
            view.subviews.forEach({ _ in counter += 1 })
        }
        
        return counter > 0
    }
}

extension String: Error {}
