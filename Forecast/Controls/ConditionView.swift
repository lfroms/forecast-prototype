//
//  ConditionView.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-22.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation
import NightNight
import UIKit

class ConditionView: UIView {
    @IBOutlet var contentView: ConditionView!
    
    @IBOutlet private var valueLabel: UILabel!
    @IBOutlet private var unitLabel: UILabel!
    @IBOutlet private var typeLabel: UILabel!
    @IBOutlet private var iconLabel: UILabel!
    
    @IBOutlet var backdropView: UIStyledView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ConditionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override var intrinsicContentSize: CGSize {
        return contentView.frame.size
    }
    
    func with(value: String?, units: String?, type: String, icon: String, color: UIColor) -> ConditionView {
        let scheme = MixedColor(normal: .black, night: .white)
        
        // Icon
        iconLabel.text = icon
        iconLabel.textColor = color
        
        // Value Label
        valueLabel.text = value ?? ""
        valueLabel.mixedTextColor = scheme
        
        // Units Label
        unitLabel.text = units ?? ""
        unitLabel.mixedTextColor = scheme
        
        // Type of Detail Label
        typeLabel.text = type
        typeLabel.mixedTextColor = scheme
        
        // Backdrop
        backdropView.mixedBackgroundColor =
            MixedColor(
                normal: UIColor(
                    red: 0.00,
                    green: 0.00,
                    blue: 0.00,
                    alpha: 0.03
                ),
                night: UIColor(
                    red: 1.00,
                    green: 1.00,
                    blue: 1.00,
                    alpha: 0.06
                )
            )
        
        invalidateIntrinsicContentSize()
        
        return self
    }
}
