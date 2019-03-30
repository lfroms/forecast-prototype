//
//  DailyForecastsView.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-29.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation
import UIKit

class DailyForecastsView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var unavailableLabel: UILabel!

    var dataSourceItems: [DailyForecastItem] = [] {
        didSet {
            stackView.subviews.forEach({ $0.removeFromSuperview() })
            unavailableLabel.isHidden = !dataSourceItems.isEmpty
            renderItems()
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
        contentView.fixInView(self, followsLayoutMargins: false)
    }

    private func renderItems() {
        for item in dataSourceItems {
            let view = DailyForecastView()
            view.configure(with: item)

            stackView.addArrangedSubview(view)
        }
    }
}
