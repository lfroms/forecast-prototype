//
//  UIChevronGrip.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-19.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation
import TweenKit
import UIKit

@IBDesignable
class UIChevronGrip: UIControl {
    @IBInspectable var defaultState: Int = 0
    @IBInspectable var weight: CGFloat = 3
    @IBInspectable var verticalOffset: CGFloat = 0
    @IBInspectable var color: UIColor =
        UIColor(
            red: 0.620,
            green: 0.620,
            blue: 0.620,
            alpha: 1.000
        )
    
    private let defaultHeight: CGFloat = 6.68
    private let defaultWidth: CGFloat = 17.6
    
    private var deltaY: CGFloat = 0
    private var shapeLayer = CAShapeLayer()
    
    private let scheduler = ActionScheduler()
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.config()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.config()
    }
    
    private func config() {
        switch self.defaultState {
        case -1:
            self.deltaY = self.defaultHeight
        case 0:
            self.deltaY = 0
        case 1:
            self.deltaY = -self.defaultHeight
        default:
            self.deltaY = self.defaultHeight
        }
        
        self.drawControl()
    }
    
    func drawControl() {
        let centerPoint = CGPoint(
            x: self.frame.width / 2,
            y: self.frame.height / 2
        )
        
        let startPoint = CGPoint(
            x: centerPoint.x,
            y: centerPoint.y + self.verticalOffset
        )
        
        let path = UIBezierPath()
        
        path.move(to: startPoint)
        path.addLine(
            to: CGPoint(
                x: startPoint.x - self.defaultWidth,
                y: startPoint.y - self.deltaY
            )
        )
        
        path.move(to: startPoint)
        path.addLine(
            to: CGPoint(
                x: startPoint.x + self.defaultWidth,
                y: startPoint.y - self.deltaY
            )
        )
        
        self.color.setStroke()
        path.lineWidth = self.weight
        path.miterLimit = 4
        path.lineCapStyle = .round
        path.stroke()
        
        self.shapeLayer.path = path.cgPath
    }
    
    public func flipDown() {
        self.scheduler.removeAll()
        let action = InterpolationAction(
            from: self.deltaY,
            to: self.defaultHeight,
            duration: 0.2,
            easing: .exponentialInOut
        ) {
            data in
            self.setNeedsDisplay()
            self.deltaY = data
        }
        
        self.scheduler.run(action: action)
    }
    
    public func flipMiddle() {
        self.scheduler.removeAll()
        let action = InterpolationAction(
            from: self.deltaY,
            to: 0,
            duration: 0.2,
            easing: .exponentialInOut
        ) {
            data in
            self.setNeedsDisplay()
            self.deltaY = data
        }
        
        self.scheduler.run(action: action)
    }
    
    public func flipUp() {
        self.scheduler.removeAll()
        let action = InterpolationAction(
            from: self.deltaY,
            to: -self.defaultHeight,
            duration: 0.2,
            easing: .exponentialInOut
        ) {
            data in
            self.setNeedsDisplay()
            self.deltaY = data
        }
        
        self.scheduler.run(action: action)
    }
    
    override func draw(_ rect: CGRect) {
        self.drawControl()
    }
}
