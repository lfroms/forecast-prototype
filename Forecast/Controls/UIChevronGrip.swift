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
    @IBInspectable private var defaultState: Int = 0 {
        didSet {
            self.config()
        }
    }
    
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
    
    enum FlipDirection {
        case up
        case neutral
        case down
    }
    
    enum FlipSpeed {
        case immediate
        case animated
    }
    
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
        
        self.setNeedsDisplay()
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
    
    public func flip(direction: FlipDirection, rate: FlipSpeed = .animated, completion: (() -> Void)? = nil) {
        self.scheduler.removeAll()
        
        var toHeight: CGFloat = 0
        
        switch direction {
        case .up:
            toHeight = -self.defaultHeight
        case .neutral:
            toHeight = 0
        case .down:
            toHeight = self.defaultHeight
        }
        
        let action = InterpolationAction(
            from: self.deltaY,
            to: toHeight,
            duration: rate == .animated ? 0.2 : 0,
            easing: .exponentialInOut
        ) {
            data in
            self.setNeedsDisplay()
            self.deltaY = data
        }
        
        let test = {
            if completion != nil {
                completion!()
            }
        }
        
        self.scheduler.run(action: action).onDidUpdate = test
    }
    
    override func draw(_ rect: CGRect) {
        self.drawControl()
    }
}
