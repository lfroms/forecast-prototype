//
//  ViewController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-15.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Hero
import Siesta
import SnapKit
import SwiftDate
import UIKit

class MainViewController: UIViewController {
    @IBOutlet var lastUpdatedLabel: UILabel!
    @IBOutlet var stationLabel: UILabel!
    @IBOutlet var currentTempLabel: UILabel!
    @IBOutlet var currentConditionLabel: UILabel!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var chevronGrip: UIChevronGrip!
    @IBOutlet var detailsScrollView: UIScrollView!
    
    @IBAction func didPressHamburger(_ sender: Any) {
        self.fetchNewData()
    }
    
    @IBAction func didPerformTouchGesture(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            self.chevronGrip.flip(direction: .neutral, rate: .immediate)
        case .ended:
            self.chevronGrip.flip(direction: .up)
        default:
            break
        }
    }
    
    @IBAction func didPerformPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        let progress = -translation.y / view.bounds.height
        
        switch sender.state {
        case .began:
            present(
                self.storyboard!.instantiateViewController(withIdentifier: "Forecast"),
                animated: true
            )
            
        case .changed:
            Hero.shared.update(progress)
        default:
            if progress > 0.3 {
                Hero.shared.finish()
                break
            }
            
            if sender.velocity(in: nil).y < -1000 {
                Hero.shared.finish()
                break
            }
            
            Hero.shared.cancel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnvCanada.shared.siteData(in: .English).addObserver(self)
        self.fetchNewData()
    }
    
    func render() {
        let resource = EnvCanada.shared.siteData(in: .English)
        
        if let data = resource.latestData?.content as! SiteData?, resource.isLoading == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.loadingIndicator.stopAnimating()
            }
            
            let cc = data.currentConditions
            
            let timestamp = cc.dateTime![1].value.timeStamp
            
            self.lastUpdatedLabel.text = timestamp
                .toDate("yyyyMMddhhmmss")?
                .toFormat("EEEE MMMM d | h:mm a")
            
            self.currentTempLabel.text = (cc.temperature != nil) ? cc.temperature!.value + "º" : "--º"
            self.stationLabel.text = data.location.name.value.uppercased()
            self.currentConditionLabel.text = cc.condition
            
            let humidity = ConditionView().with(
                value: data.currentConditions.relativeHumidity?.value, units: data.currentConditions.relativeHumidity?.units, type: "HUMIDITY", icon: "tint", color: UIColor(red: 0.13, green: 0.47, blue: 1.00, alpha: 1.0)
            )
            
            detailsScrollView.addSubview(humidity)
            humidity.snp.makeConstraints { (make) -> Void in
                make.top.bottom.equalTo(detailsScrollView)
                make.left.equalTo(detailsScrollView.snp.leftMargin)
            }
            
            let pressure = ConditionView().with(
                value: data.currentConditions.pressure?.value, units: data.currentConditions.pressure?.units, type: "PRESSURE", icon: "tachometer-alt", color: UIColor(red: 0.26, green: 0.79, blue: 0.14, alpha: 1.0)
            )
            
            detailsScrollView.addSubview(pressure)
            pressure.snp.makeConstraints { (make) -> Void in
                make.top.bottom.equalTo(detailsScrollView)
                make.left.equalTo(humidity.snp.right).offset(48)
            }
        }
    }
    
    func fetchNewData() {
        self.loadingIndicator.startAnimating()
        EnvCanada.shared.siteData(in: .English).load()
    }
}

extension MainViewController: ResourceObserver {
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        self.render()
    }
}
