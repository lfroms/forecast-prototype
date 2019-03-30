//
//  IconDetailsView.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-29.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class IconDetailsView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var stackView: UIStackView!

    var dataSourceItems: [IconDetailItem] = [] {
        didSet {
            stackView.subviews.forEach({ $0.removeFromSuperview() })
            renderItems()
        }
    }

    @IBInspectable var itemSpacing: CGFloat {
        get {
            return stackView.spacing
        }

        set {
            stackView.spacing = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        let className = String(describing: type(of: self))
        Bundle.main.loadNibNamed(className, owner: self, options: nil)
        contentView.fixInView(self, followsLayoutMargins: true)
    }

    private func renderItems() {
        for item in dataSourceItems {
            let view = IconDetailView()
            view.configure(with: item)

            stackView.addArrangedSubview(view)
        }
    }
}
