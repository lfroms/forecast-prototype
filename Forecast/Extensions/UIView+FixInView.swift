//
//  UIView+FixInView.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-27.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func fixInView(_ container: UIView!, followsLayoutMargins: Bool) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.frame
        container.addSubview(self)

        let topMargin = followsLayoutMargins ? container.layoutMargins.left : 0
        let bottomMargin = followsLayoutMargins ? -container.layoutMargins.bottom : 0
        let leftMargin = followsLayoutMargins ? container.layoutMargins.left : 0
        let rightMargin = followsLayoutMargins ? -container.layoutMargins.right : 0

        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: leftMargin).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: rightMargin).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: topMargin).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: bottomMargin).isActive = true
    }
}
