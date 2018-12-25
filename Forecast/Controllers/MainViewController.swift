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

class MainViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var stationLabel: UILabel!
    @IBOutlet var lastUpdatedLabel: UILabel!
    
    @IBOutlet var detailsScrollView: UIScrollView!
    @IBOutlet var detailsStack: DoubleStackView!
    
    @IBOutlet var currentTempLabel: UILabel!
    @IBOutlet var currentConditionLabel: UILabel!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var currentConditionsContainer: UIView!
    
    @IBOutlet var lowTempView: UIView!
    @IBOutlet var lowTempValue: UILabel!
    @IBOutlet var highTempView: UIView!
    @IBOutlet var highTempValue: UILabel!
    
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var headerBlur: UIVisualEffectView!
    
    @IBOutlet var cogIcon: UIButton!
    @IBOutlet var weatherGraphic: UIImageView!
    
    @IBOutlet var forecastStack: UIStackView!
    @IBOutlet var hourlyForecastStack: UIStackView!
    @IBOutlet var hourlyForecastContainer: UIView!
    @IBOutlet var sunriseSunsetStack: UIStackView!
    
    var blurAnimator: UIViewPropertyAnimator?
    var graphicAnimator: UIViewPropertyAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        
        self.blurView.effect = nil
        self.headerBlur.effect = nil
        
        self.blurAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
            self.blurView.effect = UIBlurEffect(style: .dark)
            self.headerBlur.effect = UIBlurEffect(style: .light)
            
            self.blurView.contentView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        }
        
        self.graphicAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
            self.weatherGraphic.alpha = 0.4
        }
        
        self.blurAnimator?.pausesOnCompletion = true
        self.graphicAnimator?.pausesOnCompletion = true
        
        EnvCanada.shared.siteData.addObserver(self)
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(MainViewController.fetchNewData),
                name: UIApplication.willEnterForegroundNotification,
                object: nil
            )
        
        NotificationCenter.default
            .addObserver(
                forName: NSNotification.Name(rawValue: "resetObservers"),
                object: nil,
                queue: nil,
                using: self.resetObserver
            )
        
        self.fetchNewData()
    }
    
    private func resetObserver(_ notification: Notification) {
        EnvCanada.shared.siteData.removeObservers(ownedBy: self)
        EnvCanada.shared.siteData.addObserver(self)
        self.fetchNewData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let totalHeight = UIScreen.main.bounds.height
        
        let blurPercentage = contentOffset / (totalHeight / 2)
        let graphicPercentage = contentOffset / (totalHeight / 5)
        
        self.graphicAnimator?.fractionComplete = graphicPercentage
        
        if blurPercentage > 0.5 {
            return
        }
        
        self.blurAnimator?.fractionComplete = blurPercentage
    }
    
    override func viewDidLayoutSubviews() {
        let screenSize: CGRect = UIScreen.main.bounds
        let topInset = self.view.safeAreaInsets.top
        let bottomInset = self.view.safeAreaInsets.bottom
        
        currentConditionsContainer.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(screenSize.height - topInset - bottomInset)
        }
        
        hourlyForecastContainer.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(
                currentConditionsContainer.snp.bottom
            ).offset(bottomInset)
        }
        
        self.scrollView.isExclusiveTouch = false
    }
    
    func render() {
        let resource = EnvCanada.shared.siteData
        
        if let data = resource.latestData?.content as! SiteData?,
            resource.isLoading == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.loadingIndicator.stopAnimating()
            }
            
            self.renderMetadata(data)
            
            do {
                try self.renderDetails(data)
            } catch {}
            
            self.renderCurrentConditions(data)
            self.renderHourlyForecast(data)
            self.renderForecast(data)
            self.renderSunriseSunset(data)
        }
    }
    
    @objc func fetchNewData() {
        self.loadingIndicator.startAnimating()
        EnvCanada.shared.siteData.load()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}

extension MainViewController: ResourceObserver {
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        if case .newData = event {
            self.render()
        }
    }
}
