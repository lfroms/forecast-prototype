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
    @IBOutlet var detailsTopRow: UIStackView!
    @IBOutlet var detailsBottomRow: UIStackView!
    
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
    
    @IBAction func didPressCog(_ sender: UIButton) {
        self.fetchNewData()
    }
    
    var blurAnimator: UIViewPropertyAnimator?
    var cogAnimator: UIViewPropertyAnimator?
    
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
        
        self.cogAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
            self.cogIcon.alpha = 0
            self.weatherGraphic.alpha = 0.4
        }
        
        self.blurAnimator?.pausesOnCompletion = true
        self.cogAnimator?.pausesOnCompletion = true
        
        EnvCanada.shared.siteData(in: .English).addObserver(self)
        self.fetchNewData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let totalHeight = UIScreen.main.bounds.height
        
        let blurPercentage = contentOffset / (totalHeight / 2)
        let cogPercentage = contentOffset / (totalHeight / 5)
        
        self.cogAnimator?.fractionComplete = cogPercentage
        
        self.cogIcon.isEnabled = cogPercentage < 0.5
        
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
    }
    
    func render() {
        let resource = EnvCanada.shared.siteData(in: .English)
        
        if let data = resource.latestData?.content as! SiteData?,
            resource.isLoading == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.loadingIndicator.stopAnimating()
            }
            
            self.renderMetadata(data)
            self.renderDetails(data)
            self.renderCurrentConditions(data)
        }
    }
    
    func fetchNewData() {
        self.loadingIndicator.startAnimating()
        EnvCanada.shared.siteData(in: .English).load()
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
