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

        let topMargin = followsLayoutMargins ? container.layoutMargins.top : 0
        let bottomMargin = followsLayoutMargins ? -container.layoutMargins.bottom : 0
        let leftMargin = followsLayoutMargins ? container.layoutMargins.left : 0
        let rightMargin = followsLayoutMargins ? -container.layoutMargins.right : 0

        leftAnchor.constraint(equalTo: container.leftAnchor, constant: leftMargin).isActive = true
        rightAnchor.constraint(equalTo: container.rightAnchor, constant: rightMargin).isActive = true
        topAnchor.constraint(equalTo: container.topAnchor, constant: topMargin).isActive = true
        bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: bottomMargin).isActive = true
    }
}
