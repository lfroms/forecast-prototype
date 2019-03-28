//
//  MainViewController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-15.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Apollo
import SnapKit
import SwiftDate
import UIKit

class MainViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var overviewView: OverviewView!
    
    @IBOutlet var detailsScrollView: UIScrollView!
    @IBOutlet var detailsStack: DoubleStackView!
    
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var headerBlur: UIVisualEffectView!
    
    @IBOutlet var cogIcon: UIButton!
    @IBOutlet var weatherGraphic: UIImageView!
    
    @IBOutlet var forecastStack: UIStackView!
    @IBOutlet var hourlyForecastStack: UIStackView!
    @IBOutlet var sunriseSunsetStack: UIStackView!
    
    @IBOutlet var currentConditionsContainer: UIView!
    @IBOutlet var forecastsStack: UIStackView!
    
    @IBOutlet var noDailyForecastLabel: UILabel!
    @IBOutlet var noHourlyForecastLabel: UILabel!
    
    @IBOutlet var warningsStack: UIStackView!
    @IBOutlet var weatherGraphicOffset: NSLayoutConstraint!
    @IBOutlet var warningsContainer: UIStyledView!
    
    @IBOutlet var yesterdayConditionsContainer: UIView!
    @IBOutlet var yesterdayHighLabel: UILabel!
    @IBOutlet var yesterdayLowLabel: UILabel!
    @IBOutlet var yesterdayPrecipLabel: UILabel!
    
    @IBOutlet var regionalNormalsContainer: UIView!
    @IBOutlet var normalHighLabel: UILabel!
    @IBOutlet var normalLowLabel: UILabel!
    
    private var blurAnimator: UIViewPropertyAnimator?
    private var headerAnimator: UIViewPropertyAnimator?
    private var graphicAnimator: UIViewPropertyAnimator?
    
    private var apolloWatcher: GraphQLQueryWatcher<WeatherQuery>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        
        self.blurView.effect = nil
        self.headerBlur.effect = nil
        
        self.blurAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
            self.blurView.effect = UIBlurEffect(style: .dark)
            self.blurView.contentView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        }
        
        self.headerAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
            self.headerBlur.effect = UIBlurEffect(style: .light)
        }
        
        self.graphicAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
            self.weatherGraphic.alpha = 0.4
        }
        
        self.blurAnimator?.pausesOnCompletion = true
        self.headerAnimator?.pausesOnCompletion = true
        self.graphicAnimator?.pausesOnCompletion = true
        
        NotificationCenter.default
            .addObserver(
                forName: UIApplication.willEnterForegroundNotification,
                object: nil,
                queue: nil,
                using: self.fetch
            )
        
        NotificationCenter.default
            .addObserver(
                forName: NSNotification.Name(rawValue: "resetObservers"),
                object: nil,
                queue: nil,
                using: self.resetObserverAndFetch
            )
        
        self.setObserverForDefaultSite()
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
        
        let limitedBlur = blurPercentage >= 0.5 ? 0.5 : blurPercentage
        
        if self.warningsStack.arrangedSubviews.isEmpty {
            self.headerAnimator?.fractionComplete = limitedBlur
        } else {
            self.headerAnimator?.fractionComplete = 0
        }
        
        self.graphicAnimator?.fractionComplete = graphicPercentage
        self.blurAnimator?.fractionComplete = limitedBlur
    }
    
    override func viewDidLayoutSubviews() {
        let screenSize: CGRect = UIScreen.main.bounds
        let topInset = self.view.safeAreaInsets.top
        let bottomInset = self.view.safeAreaInsets.bottom
        
        currentConditionsContainer.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(screenSize.height - topInset - bottomInset)
        }
        
        forecastsStack.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(
                currentConditionsContainer.snp.bottom
            ).offset(bottomInset > 0 ? bottomInset : 10)
        }
        
        weatherGraphicOffset.constant = warningsContainer.frame.height
        
        self.scrollView.isExclusiveTouch = false
    }
    
    func render(_ result: GraphQLResult<WeatherQuery.Data>?) {
        guard let data = result?.data?.weather else {
            return
        }
        
        self.renderMetadata(data)
        
        do {
            try self.renderDetails(data)
        } catch {}
        
        self.renderWarnings(data)
        self.renderOverview(data)
        self.renderHourlyForecast(data)
        self.renderForecast(data)
        self.renderSunriseSunset(data)
        self.renderYesterdayConditions(data)
        self.renderRegionalNormals(data)
        
        // Update scroll animations in case some properties change
        self.scrollViewDidScroll(self.scrollView)
    }
    
    private func setObserverForDefaultSite() {
        self.apolloWatcher?.cancel()
        
        let site = UserPreferences.defaultSite()
        guard let defaultSite = site else {
            return
        }
        
        let query = WeatherQuery(region: defaultSite.region, code: defaultSite.code)
        
        self.apolloWatcher = apollo.watch(query: query) { result, error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.overviewView.setLoading(false)
            }
            
            guard error == nil else {
                Alert.show(
                    self,
                    title: "Oops!",
                    message: "Something isn't working correctly. Try again later."
                )
                
                return
            }
            
            self.render(result)
        }
    }
    
    private func fetchNewData() {
        let site = UserPreferences.defaultSite()
        guard site != nil else {
            return
        }
        
        let query = WeatherQuery(region: site!.region, code: site!.code)
        self.overviewView.setLoading(true)
        
        apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheData)
    }
    
    private func resetObserverAndFetch(_ notification: Notification) {
        self.setObserverForDefaultSite()
        self.fetchNewData()
    }
    
    private func fetch(_ notification: Notification) {
        self.fetchNewData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
