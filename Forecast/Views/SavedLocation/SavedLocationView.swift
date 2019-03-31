//
//  SavedLocationView.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-31.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import UIKit

struct SavedLocationItem {
    let name: String
    let condition: String
    let temperature: String
    let isCurrentLocation: Bool
}

class SavedLocationView: UIView {
    @IBOutlet private var contentView: UIView!

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var conditionLabel: UILabel!
    @IBOutlet private var temperatureLabel: UILabel!
    @IBOutlet private var currentLocationIcon: UIImageView!

    var index: Int?

    private static let highlightColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    private static let standardColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08)

    var isSelected: Bool {
        get {
            return contentView.backgroundColor == SavedLocationView.highlightColor
        }
        set {
            UIView.animate(withDuration: 0.15) {
                self.contentView.backgroundColor =
                    newValue
                    ? SavedLocationView.highlightColor
                    : SavedLocationView.standardColor
            }
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

    // MARK: - Configurations

    func configure(with item: SavedLocationItem, index: Int) {
        nameLabel.text = item.name
        conditionLabel.text = item.condition
        temperatureLabel.text = item.temperature
        currentLocationIcon.isHidden = !item.isCurrentLocation

        self.index = index
    }
}
