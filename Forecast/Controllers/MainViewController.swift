//
//  ViewController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-15.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Siesta
import SnapKit
import SwiftDate
import UIKit

class MainViewController: UIViewController {
    @IBOutlet var stationLabel: UILabel!
    @IBOutlet var lastUpdatedLabel: UILabel!
    
    @IBOutlet var detailsScrollView: UIScrollView!
    @IBOutlet var detailsTopRow: UIStackView!
    @IBOutlet var detailsBottomRow: UIStackView!
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var cogIcon: UIButton!
    @IBAction func didPressCog(_ sender: Any) {
        self.fetchNewData()
    }
    
    var initialScrollViewPosition: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnvCanada.shared.siteData(in: .English).addObserver(self)
        self.fetchNewData()
    }
    
    func render() {
        let resource = EnvCanada.shared.siteData(in: .English)
        
        if let data = resource.latestData?.content as! SiteData?, resource.isLoading == false {
            let cc = data.currentConditions
            self.addDetailSubviews(cc)
            
            self.stationLabel.text = data.location.name.value
            
            let timestamp = cc.dateTime![1].value.timeStamp
            self.lastUpdatedLabel.text = timestamp
                .toDate("yyyyMMddhhmmss")?
                .toFormat("MMM d h:mm a")
            
            if self.initialScrollViewPosition != nil {
                self.initialScrollViewPosition = self.detailsScrollView.frame.origin
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PageEmbedSegue" {
            let embedVC = segue.destination as! WeatherPageController
            embedVC.mainVC = self
        }
    }
    
    func onTransitionProgress(_ percent: CGFloat) {
        let distance = view.frame.height - initialScrollViewPosition.y
        let change = initialScrollViewPosition.y + (distance * percent)
        
        self.detailsScrollView.frame.origin.y = change
        self.detailsScrollView.alpha = 1 - (1.3 * percent)
    }
    
    func fetchNewData() {
        EnvCanada.shared.siteData(in: .English).load()
    }
}

extension MainViewController: ResourceObserver {
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        self.render()
    }
}
