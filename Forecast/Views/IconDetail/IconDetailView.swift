//
//  IconDetailView.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-29.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation
import UIKit

struct IconDetailItem {
    let icon: String
    let detail: String
}

class IconDetailView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var iconLabel: UILabel!
    @IBOutlet private var detailLabel: UILabel!

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

    // MARK: - Configuration

    func configure(with item: IconDetailItem) {
        iconLabel.text = item.icon
        detailLabel.text = item.detail
    }
}
