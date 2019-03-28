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

    @IBOutlet var stationName: UILabel!
    @IBOutlet private var currentConditionsTimestamp: UILabel!

    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private var currentTemperature: UILabel!
    @IBOutlet private var currentCondition: UILabel!

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

    // MARK: - Public Functions

    func setLoading(_ loading: Bool) {
        if loading {
            loadingIndicator.startAnimating()
            return
        }

        loadingIndicator.stopAnimating()
    }

    func setTemperature(_ temperature: String?) {
        guard let temperature = temperature else {
            currentTemperature.text = "--°"
            return
        }

        currentTemperature.text = "\(temperature)°"
    }

    func setHighTemp(_ temperature: String?) {
        guard let temperature = temperature else {
            setShowForecastHigh(false)
            return
        }

        setShowForecastHigh(true)
        forecastHighTemp.text = "\(temperature)°"
    }

    func setLowTemp(_ temperature: String?) {
        guard let temperature = temperature else {
            setShowForecastLow(false)
            return
        }

        setShowForecastLow(true)
        forecastLowTemp.text = "\(temperature)°"
    }

    func setCurrentCondition(_ condition: String?) {
        guard let condition = condition, !condition.isEmpty else {
            currentCondition.text = "Not Observed"
            return
        }

        currentCondition.text = condition
    }

    func setDateStamp(_ dateStamp: String?) {
        currentConditionsTimestamp.text =
            dateStamp?
            .toDate("yyyyMMddHHmmss", region: .UTC)?
            .convertTo(region: .current)
            .toFormat("MMM d 'at' h:mm a", locale: Locales.current)
    }

    // MARK: - Private Functions

    private func setShowForecastHigh(_ visible: Bool) {
        forecastHighContainer.isHidden = !visible
    }

    private func setShowForecastLow(_ visible: Bool) {
        forecastLowContainer.isHidden = !visible
    }
}
