//
//  ForecastViewController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-20.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation
import Siesta
import UIKit

class ForecastViewController: UIViewController {
    @IBOutlet var forecastStack: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        EnvCanada.shared.siteData(in: .English).addObserver(self)
    }

    func render() {
        let resource = EnvCanada.shared.siteData(in: .English)

        if let data = resource.latestData?.content as! SiteData?, resource.isLoading == false {
            forecastStack.subviews.forEach({ $0.removeFromSuperview() })

            data.forecastGroup.forecast.forEach(
                { item in
                    let description = item.abbreviatedForecast.textSummary!

                    let subview = ForecastItem().with(
                        iconCode: item.abbreviatedForecast.iconCode,
                        condition: description + (description.hasWhiteSpace() ? "." : ""),
                        date: item.period.textForecastName.uppercased(),
                        temperature: item.temperatures.first!.value + "°",
                        pop: item.abbreviatedForecast.pop.value
                    )

                    forecastStack.addArrangedSubview(subview)
                }
            )
        }
    }
}

extension ForecastViewController: ResourceObserver {
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        render()
    }
}
