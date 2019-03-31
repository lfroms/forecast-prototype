//
//  OptionsViewController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-30.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Apollo
import UIKit

class OptionsViewController: UIViewController {
    @IBOutlet private var dataInfoView: DataInfoView!
    @IBOutlet private var savedLocationsView: SavedLocationsView!
    
    @IBAction private func returnToMain(_ button: UIButton) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedLocationsView.dataSourceItems = [
            SavedLocationItem(name: "Ottawa", condition: "Partly Cloudy", temperature: "5º", isCurrentLocation: true),
            SavedLocationItem(name: "Ottawa", condition: "Partly Cloudy", temperature: "5º", isCurrentLocation: false),
            SavedLocationItem(name: "Ottawa", condition: "Partly Cloudy", temperature: "5º", isCurrentLocation: false)
        ]
        
        savedLocationsView.didTapItem = { index in
            self.savedLocationsView.highlightedItem = index
        }
        
        guard let site = UserPreferences.defaultSite() else {
            return
        }
        
        let query = WeatherQuery(region: site.region, code: site.code)
        
        apollo.fetch(query: query, cachePolicy: .returnCacheDataElseFetch) { result, _ in
            guard let data = result?.data?.weather else {
                return
            }
            
            let infoData = DataInfoViewModel(
                currentConditions: data.currentConditions,
                forecastGroup: data.forecastGroup
            ).data
            
            self.dataInfoView.configure(with: infoData)
        }
    }
}
