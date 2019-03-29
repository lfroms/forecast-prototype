//
//  OverviewView.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-27.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import SwiftDate
import UIKit

class OverviewView: UIView {
    @IBOutlet var contentView: UIView!

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

    // MARK: - Public Variables

    var stationName: String? {
        get { return stationNameLabel.text }

        set {
            stationNameLabel.text = newValue
        }
    }

    var loading: Bool {
        get { return loadingIndicator.isAnimating }

        set {
            newValue
                ? loadingIndicator.startAnimating()
                : loadingIndicator.stopAnimating()
        }
    }

    var temperature: String? {
        get { return temperatureLabel.text }

        set {
            temperatureLabel.text = (newValue ?? "--") + "°"
        }
    }

    var highTemp: String? {
        get { return forecastHighTemp.text }

        set {
            guard let temperature = newValue else {
                setShowForecastHigh(false)
                return
            }

            setShowForecastHigh(true)
            forecastHighTemp.text = "\(temperature)°"
        }
    }

    var lowTemp: String? {
        get { return forecastLowTemp.text }

        set {
            guard let temperature = newValue else {
                setShowForecastLow(false)
                return
            }

            setShowForecastLow(true)
            forecastLowTemp.text = "\(temperature)°"
        }
    }

    var currentCondition: String? {
        get { return currentConditionLabel.text }

        set {
            guard let condition = newValue, !condition.isEmpty else {
                currentConditionLabel.text = "Not Observed"
                return
            }

            currentConditionLabel.text = condition
        }
    }

    var dateStamp: String? {
        get { return currentConditionsTimestamp.text }

        set {
            currentConditionsTimestamp.text =
                newValue?
                .toDate("yyyyMMddHHmmss", region: .UTC)?
                .convertTo(region: .current)
                .toFormat("MMM d 'at' h:mm a", locale: Locales.current)
        }
    }

    // MARK: - Private Functions

    private func setShowForecastHigh(_ visible: Bool) {
        forecastHighContainer.isHidden = !visible
    }

    private func setShowForecastLow(_ visible: Bool) {
        forecastLowContainer.isHidden = !visible
    }
}
