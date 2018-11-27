//
//  AlertsViewController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-11-26.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Siesta
import UIKit

class AlertsViewController: UIViewController {
    @IBOutlet var alertsStack: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        EnvCanada.shared.siteData(in: .English).addObserver(self)
    }

    func render() {
        let resource = EnvCanada.shared.siteData(in: .English)

        if let data = resource.latestData?.content as! SiteData?, resource.isLoading == false {
            alertsStack.subviews.forEach({ $0.removeFromSuperview() })

            data.warnings?.events!.forEach(
                { event in
                    let timestamp = event.dateTime![1].value.timeStamp.toDate("yyyyMMddhhmmss")?
                        .toFormat("MMM d h:mm a")

                    let subview = AlertItem().with(
                        icon: iconForAlertPriority(event.priority),
                        title: event.description!,
                        description: timestamp,
                        priority: event.priority,
                        url: data.warnings!.url
                    )

                    alertsStack.addArrangedSubview(subview)
                }
            )
        }
    }

    private func iconForAlertPriority(_ priority: AlertPriority?) -> String {
        switch priority {
        case .low?:
            return "info-circle"
        case .medium?:
            return "exclamation-circle"
        case .high?:
            return "exclamation-triangle"
        default:
            return "info-circle"
        }
    }
}

extension AlertsViewController: ResourceObserver {
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        render()
    }
}
