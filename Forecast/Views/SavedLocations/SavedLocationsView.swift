//
//  SavedLocationsView.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-31.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation
import UIKit

class SavedLocationsView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var noSavedLocationsLabel: UILabel!

    var dataSourceItems: [SavedLocationItem] = [] {
        didSet {
            stackView.subviews.forEach({ $0.removeFromSuperview() })
            noSavedLocationsLabel.isHidden = !dataSourceItems.isEmpty
            renderItems()
        }
    }

    var didTapItem: ((Int) -> Void)?
    var highlightedItem: Int? {
        willSet(newValue) {
            stackView.subviews.forEach { subview in
                let savedLocationView = subview as? SavedLocationView
                savedLocationView?.isSelected = savedLocationView?.index == newValue
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

    private func renderItems() {
        for (index, item) in dataSourceItems.enumerated() {
            let view = SavedLocationView()
            view.configure(with: item, index: index)

            if let highlightedItem = highlightedItem {
                view.isSelected = index == highlightedItem
            }

            stackView.addArrangedSubview(view)
        }
    }

    @IBAction func didReceiveTapGesture(_ sender: UITapGestureRecognizer) {
        guard let didTapItem = didTapItem else {
            return
        }

        for subview in stackView.arrangedSubviews {
            guard let item = subview as? SavedLocationView else {
                return
            }

            if item.frame.contains(sender.location(in: stackView)) {
                didTapItem(item.index ?? 0)
            }
        }
    }
}
