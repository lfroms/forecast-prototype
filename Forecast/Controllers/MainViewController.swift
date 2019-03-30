//
//  MainViewController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-10-15.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Apollo
import SwiftDate
import UIKit

class MainViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var illustration: UIImageView!
    @IBOutlet var illustrationOffset: NSLayoutConstraint!
    @IBOutlet var cogIcon: UIButton!
    
    @IBOutlet var currentConditionsContainer: UIView!
    
    @IBOutlet var overviewView: OverviewView!
    @IBOutlet var observationsView: ObservationsView!
    
    @IBOutlet var forecastsStack: UIStackView!
    
    @IBOutlet var hourlyForecastsView: HourlyForecastsView!
    @IBOutlet var dailyForecastsView: DailyForecastsView!
    @IBOutlet var sunriseSunsetView: ObservationsView!
    @IBOutlet var yesterdayContainerView: UIStackView!
    @IBOutlet var yesterdayIconDetailView: IconDetailsView!
    @IBOutlet var regionalNormalsContainerView: UIStackView!
    @IBOutlet var regionalNormalsIconDetailView: IconDetailsView!
    
    private var blurAnimator: UIViewPropertyAnimator?
    private var illustrationAnimator: UIViewPropertyAnimator?
    
    private var apolloWatcher: GraphQLQueryWatcher<WeatherQuery>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delegate = self
        
        self.blurView.effect = nil
        self.blurAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
            self.blurView.effect = UIBlurEffect(style: .dark)
            self.blurView.contentView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        }
        
        self.illustrationAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
            self.illustration.alpha = 0.4
        }
        
        self.blurAnimator?.pausesOnCompletion = true
        self.illustrationAnimator?.pausesOnCompletion = true
        
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
        let illustrationPercentage = contentOffset / (totalHeight / 5)
        
        let limitedBlur = min(blurPercentage, 0.5)
        
        headerView.animationProgress = limitedBlur
        illustrationAnimator?.fractionComplete = illustrationPercentage
        blurAnimator?.fractionComplete = limitedBlur
    }
    
    override func viewDidLayoutSubviews() {
        let screenSize: CGRect = UIScreen.main.bounds
        let topInset = view.safeAreaInsets.top
        let bottomInset = view.safeAreaInsets.bottom
        
        illustrationOffset.constant = headerView.warningsHeight
        
        currentConditionsContainer
            .heightAnchor
            .constraint(
                equalToConstant: screenSize.height - topInset - bottomInset
            ).isActive = true
        
        forecastsStack
            .topAnchor
            .constraint(
                equalTo: currentConditionsContainer.bottomAnchor,
                constant: bottomInset > 0 ? bottomInset : 10
            ).isActive = true
    }
    
    func render(_ result: GraphQLResult<WeatherQuery.Data>?) {
        guard let data = result?.data?.weather else {
            return
        }
        
        self.renderMetadata(data)
        
        self.renderWarnings(data)
        self.renderOverview(data)
        self.renderObservations(data)
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
                self.overviewView.loading = false
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
        self.overviewView.loading = true
        
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
