//
//  OverviewView.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-27.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import SwiftDate
import UIKit

struct OverviewData {
    let stationName: String
    let temperature: String?
    let highTemp: String?
    let lowTemp: String?
    let currentCondition: String?
    let date: String?
}

class OverviewView: UIView {
    @IBOutlet private var contentView: UIView!

    @IBOutlet private var stationNameLabel: UILabel!
    @IBOutlet private var currentConditionsTimestamp: UILabel!

    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private var temperatureLabel: UILabel!
    @IBOutlet private var currentConditionLabel: UILabel!

    @IBOutlet private var forecastHighContainer: UIView!
    @IBOutlet private var forecastHighTemp: UILabel!
    @IBOutlet private var forecastLowContainer: UIView!
    @IBOutlet private var forecastLowTemp: UILabel!

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
        contentView.fixInView(self, followsLayoutMargins: true)
    }

    // MARK: - Configuration

    func configure(with data: OverviewData) {
        stationNameLabel.text = data.stationName

        temperatureLabel.text = (data.temperature ?? "--") + "°"

        if let highTemp = data.highTemp {
            forecastHighTemp.text = "\(highTemp)°"
        }

        forecastHighContainer.isHidden = data.highTemp?.isEmpty ?? true

        if let lowTemp = data.lowTemp {
            forecastLowTemp.text = "\(lowTemp)°"
        }

        forecastLowContainer.isHidden = data.lowTemp?.isEmpty ?? true

        if let condition = data.currentCondition, !condition.isEmpty {
            currentConditionLabel.text = condition
        } else {
            currentConditionLabel.text = "Not Observed"
        }

        currentConditionsTimestamp.text =
            data.date?
            .toDate("yyyyMMddHHmmss", region: .UTC)?
            .convertTo(region: .current)
            .toFormat("MMM d 'at' h:mm a", locale: Locales.current)
    }

    // MARK: - Public Variables

    var loading: Bool {
        get { return loadingIndicator.isAnimating }

        set {
            newValue
                ? loadingIndicator.startAnimating()
                : loadingIndicator.stopAnimating()
        }
    }
}
