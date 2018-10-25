//
//  ConditionView.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-22.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation
import UIKit

class ConditionView: UIView {
    @IBOutlet var contentView: ConditionView!
    
    @IBOutlet private var valueLabel: UILabel!
    @IBOutlet private var unitLabel: UILabel!
    @IBOutlet private var typeLabel: UILabel!
    @IBOutlet private var iconLabel: UILabel!
    @IBOutlet private var colorBox: UIStyledView!
    
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
    
    func with(value: String?, units: String?, type: String, icon: String, color: UIColor, isOutlined: Bool = false) -> ConditionView {
        // Color Box
        colorBox.borderColor = color
        colorBox.backgroundColor = isOutlined ? .clear : color
        colorBox.shadowColor = isOutlined ? .clear : color
        
        // Icon
        iconLabel.text = icon
        iconLabel.textColor = isOutlined ? color : .white
        
        // Value Label
        valueLabel.text = value ?? ""
        valueLabel.textColor = isOutlined ? color : .white
        
        // Units Label
        unitLabel.text = units ?? ""
        unitLabel.textColor = isOutlined ? color : .white
        
        // Type of Detail Label
        typeLabel.text = type
        
        invalidateIntrinsicContentSize()
        
        return self
    }
}
