//
//  Alert.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-10.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    static func show(_ context: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        context.present(alertController, animated: true, completion: nil)
    }
}
