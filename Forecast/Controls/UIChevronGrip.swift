//
//  UIChevronGrip.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-19.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class UIChevronGrip: UIControl {
    @IBInspectable var chevronState: Int = 1
    @IBInspectable var weight: CGFloat = 3
    @IBInspectable var color: UIColor =
        UIColor(
            red: 0.620,
            green: 0.620,
            blue: 0.620,
            alpha: 1.000
        )
    @IBInspectable var verticalOffset: CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        let centerPoint = CGPoint(
            x: self.frame.width / 2,
            y: self.frame.height / 2
        )
        
        let deltaX: CGFloat = 17.6
        var deltaY: CGFloat
        
        switch self.chevronState {
        case -1:
            deltaY = 6.68
        case 0:
            deltaY = 0
        case 1:
            deltaY = -6.68
        default:
            deltaY = 6.68
        }
        
        let startPoint = CGPoint(
            x: centerPoint.x,
            y: centerPoint.y + self.verticalOffset
        )
        
        let path = UIBezierPath()
        
        path.move(to: startPoint)
        path.addLine(
            to: CGPoint(
                x: startPoint.x - deltaX,
                y: startPoint.y - deltaY
            )
        )
        
        path.move(to: startPoint)
        path.addLine(
            to: CGPoint(
                x: startPoint.x + deltaX,
                y: startPoint.y - deltaY
            )
        )
        
        self.color.setStroke()
        path.lineWidth = self.weight
        path.miterLimit = 4
        path.lineCapStyle = .round
        path.stroke()
    }
}
