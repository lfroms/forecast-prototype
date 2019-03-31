//
//  DataInfoView.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-30.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation
import UIKit

struct DataInfoData {
    let locationName: String?
    let forecastIssueDate: String?
}

class DataInfoView: UIView {
    @IBOutlet private var contentView: UIView!

    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var locationContainer: UIView!

    @IBOutlet private var forecastIssueDateLabel: UILabel!
    @IBOutlet private var forecastIssueContainer: UIView!

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

    func configure(with data: DataInfoData) {
        locationLabel.text = data.locationName
        locationContainer.isHidden = data.locationName?.isEmpty ?? true

        forecastIssueDateLabel.text = data.forecastIssueDate
        forecastIssueContainer.isHidden = data.forecastIssueDate?.isEmpty ?? true
    }
}
