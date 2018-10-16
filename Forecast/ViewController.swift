//
//  ViewController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-15.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
            CurrentConditions.getCurrentConditions()
                .done { data -> Void in
                    self.currentTempLabel.text = data["currentConditions"]["temperature"].element!.text + "º"
                    self.stationLabel.text = data["location"]["region"].element!.text.uppercased()
                    try self.lastUpdatedLabel.text = data["currentConditions"]["dateTime"].withAttribute("zone", "EDT")["textSummary"].element?.text
                } .catch { error -> Void in
                    print("Error!")
        }
    }
}
