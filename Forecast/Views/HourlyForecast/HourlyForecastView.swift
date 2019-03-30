//
//  HourlyForecastView.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-29.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation
import SwiftDate
import UIKit

struct HourlyForecastItem {
    let timeStamp: String
    let icon: String
    let temperature: String
    let temperatureUnits: String
    let windSpeed: String?
    let windSpeedUnits: String
    let pop: String?
}

class HourlyForecastView: UICollectionViewCell {
    @IBOutlet private var view: UIView!

    @IBOutlet private var hourLabel: UILabel!
    @IBOutlet private var amPmLabel: UILabel!
    @IBOutlet private var iconLabel: UILabel!

    @IBOutlet private var temperatureContainer: UIView!
    @IBOutlet private var temperatureLabel: UILabel!
    @IBOutlet private var temperatureUnitsLabel: UILabel!

    @IBOutlet private var windSpeedLabel: UILabel!
    @IBOutlet private var popContainer: UIView!
    @IBOutlet private var popLabel: UILabel!

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
        view.fixInView(self, followsLayoutMargins: false)
    }

    // MARK: - Configuration

    func configure(with item: HourlyForecastItem) {
        let hour = item.timeStamp
            .toDate("yyyyMMddHHmm", region: .UTC)?
            .convertTo(region: .current)
            .toFormat("h")

        let amPm = item.timeStamp
            .toDate("yyyyMMddHHmm", region: .UTC)?
            .convertTo(region: .current)
            .toFormat("a")

        hourLabel.text = hour
        amPmLabel.text = amPm

        iconLabel.text = item.icon
        temperatureLabel.text = item.temperature
        temperatureUnitsLabel.text = item.temperatureUnits

        if let windSpeed = item.windSpeed {
            // Sometimes, the wind speed can be a string, such as "Calm", in which
            // case we do not want to show the units.
            let units = Int(windSpeed) != nil ? item.windSpeedUnits : ""
            windSpeedLabel.text = "\(windSpeed) \(units)"
        }

        if let pop = item.pop {
            popLabel.text = pop + "%"
            popContainer.isHidden = false
        } else {
            popContainer.isHidden = true
        }
    }

    // MARK: - Static Functions

    static func getClassName() -> String {
        return String(describing: type(of: self))
    }
}
