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
    @IBOutlet private var scrollView: UIScrollView!
    
    @IBOutlet private var headerView: HeaderView!
    @IBOutlet private var blurView: UIVisualEffectView!
    @IBOutlet private var illustration: UIImageView!
    @IBOutlet private var illustrationOffset: NSLayoutConstraint!
    @IBOutlet private var cogIcon: UIButton!
    
    @IBOutlet private var currentConditionsContainer: UIView!
    
    @IBOutlet private var overviewView: OverviewView!
    @IBOutlet private var observationsView: ObservationsView!
    
    @IBOutlet private var forecastsStack: UIStackView!
    
    @IBOutlet private var hourlyForecastsView: HourlyForecastsView!
    @IBOutlet private var dailyForecastsView: DailyForecastsView!
    @IBOutlet private var sunriseSunsetView: ObservationsView!
    @IBOutlet private var yesterdayContainerView: UIStackView!
    @IBOutlet private var yesterdayIconDetailView: IconDetailsView!
    @IBOutlet private var regionalNormalsContainerView: UIStackView!
    @IBOutlet private var regionalNormalsIconDetailView: IconDetailsView!
    
    private var blurAnimator: UIViewPropertyAnimator?
    private var illustrationAnimator: UIViewPropertyAnimator?
    
    private var apolloWatcher: GraphQLQueryWatcher<WeatherQuery>?
    
    // MARK: - ViewController Lifecycle
    
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
    
    // MARK: - Data Retrieval
    
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
    
    // MARK: - Renderers
    
    /**
     Takes a GraphQL result and sends the data to various view-models
     that create the necessary data structures for the subviews.
     
     - Parameters:
       - result: Object containing the weather data returned from GraphQL.
     */
    
    func render(_ result: GraphQLResult<WeatherQuery.Data>?) {
        guard let data = result?.data?.weather else {
            return
        }
        
        // Metadata 📑 (Illustration, Background Color)
        self.renderVisuals(data)
        
        // Warnings ⚠️
        let warningItems = EventsViewModel(
            data.warnings.events,
            url: data.warnings.url
        ).items
        self.headerView.warnings = warningItems
        
        // Overview 🌤 (Station Name, Temperature, ...)
        let overviewData = OverviewViewModel(data).data
        overviewView.configure(with: overviewData)
        
        // Observations 📊
        let observationItems = ObservationsViewModel(data.currentConditions).items
        observationsView.dataSourceItems = observationItems
        observationsView.isHidden = observationItems.isEmpty
        
        // Forecasts 📆
        let hourlyForecastItems = HourlyForecastsViewModel(
            data.hourlyForecastGroup?.hourlyForecast
        ).items
        hourlyForecastsView.dataSourceItems = hourlyForecastItems
        
        let dailyForecastItems = DailyForecastsViewModel(
            data.forecastGroup.forecast
        ).items
        dailyForecastsView.dataSourceItems = dailyForecastItems
        
        // Sunrise/Sunset ☀️
        sunriseSunsetView.dataSourceItems = RiseSetViewModel(data.riseSet).items
        
        // Yesterday Conditions ↺
        let ycItems = YesterdayConditionViewModel(data.yesterdayConditions).items
        yesterdayIconDetailView.dataSourceItems = ycItems
        yesterdayContainerView.isHidden = ycItems.isEmpty
        
        // Regional Normals 📈
        let rnItems = RegionalNormalsViewModel(data.forecastGroup.regionalNormals).items
        regionalNormalsIconDetailView.dataSourceItems = rnItems
        regionalNormalsContainerView.isHidden = rnItems.isEmpty
        
        // Update scroll animations in case some properties change
        self.scrollViewDidScroll(self.scrollView)
    }
    
    private func renderVisuals(_ data: WeatherQuery.Data.Weather) {
        self.illustration.contentMode = .top
        
        guard let code = data.currentConditions.iconCode?.value, !code.isEmpty else {
            view.backgroundColor = UIColor(named: "06")
            self.illustration.image = UIImage(named: "03-image")?.aspectFitImage(inRect: self.illustration.frame)
            
            return
        }
        
        UIView.animate(
            withDuration: 0.5, delay: 0.0, animations: {
                let color = UIColor(named: code) ?? UIColor(named: "06")
                self.view.backgroundColor = color
            }, completion: nil
        )
        
        let image = UIImage(named: "\(code)-image") ?? UIImage(named: "03-image")
        illustration.image = image?.aspectFitImage(inRect: illustration.frame)
    }
    
    // MARK: - System Overrides
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
