//
//  ObservationView.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-22.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation
import UIKit

struct ObservationItem {
    let icon: String
    let value: String
    let units: String
    let description: String
    let prefix: String?
}

class ObservationView: UICollectionViewCell {
    @IBOutlet private var view: UIView!

    @IBOutlet private var iconLabel: UILabel!
    @IBOutlet private var valueLabel: UILabel!
    @IBOutlet private var unitsLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var prefixLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        let className = String(describing: type(of: self))
        Bundle.main.loadNibNamed(className, owner: self, options: nil)
        view.fixInView(self, followsLayoutMargins: false)
    }
    
    // MARK: - Configuration

    func configure(with item: ObservationItem) {
        iconLabel.text = item.icon
        valueLabel.text = item.value
        unitsLabel.text = item.units
        descriptionLabel.text = item.description.uppercased()

        if let prefix = item.prefix {
            prefixLabel.text = prefix
            prefixLabel.isHidden = false
        } else {
            prefixLabel.isHidden = true
        }
    }
    
    // MARK: - Static Functions

    static func getClassName() -> String {
        return String(describing: type(of: self))
    }
}
