//
//  ViewController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-15.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import UIKit
import SwiftDate

class ViewController: UIViewController {

    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentConditionLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBAction func didPressHamburger(_ sender: Any) {
        getData()
    }
    
    func getData() {
        self.loadingIndicator.startAnimating()
        
        Weather.fetchWeather(stationCode: "25")
            .done { data -> Void in
                
                let timestamp = data.dateTime[0].value.timeStamp
                
                self.lastUpdatedLabel.text = timestamp
                    .toDate("yyyymmddhhmmss")?
                    .toFormat("EEEE MMMM d yyyy | h:mm a")
                
                self.currentTempLabel.text = data.temperature.value + "º"
                self.stationLabel.text = data.station.value.uppercased()
                self.currentConditionLabel.text = data.condition
                
                self.loadingIndicator.stopAnimating()
                
            } .catch { error -> Void in
                print(error)
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getData()
    }
}
