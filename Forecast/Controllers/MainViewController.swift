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
    @IBOutlet var ccPageSize: UIView!
    
    @IBOutlet var lowTempView: UIView!
    @IBOutlet var lowTempValue: UILabel!
    @IBOutlet var highTempView: UIView!
    @IBOutlet var highTempValue: UILabel!
    
    @IBOutlet var blurView: UIVisualEffectView!
    
    @IBOutlet var cogIcon: UIButton!
    
    @IBAction func didPressCog(_ sender: Any) {
        self.fetchNewData()
    }
    
    var animator: UIViewPropertyAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        
        self.animator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
            self.blurView.effect = nil
            self.blurView.contentView.alpha = 0
        }
        
        self.animator?.isReversed = true
        
        EnvCanada.shared.siteData(in: .English).addObserver(self)
        self.fetchNewData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newValue = CGFloat(scrollView.contentOffset.y / (UIScreen.main.bounds.height / 2))
        
        if newValue > 0.5 {
            return
        }
        
        self.animator?.fractionComplete = newValue
    }
    
    override func viewDidLayoutSubviews() {
        let screenSize: CGRect = UIScreen.main.bounds
        let topInset = self.view.safeAreaInsets.top
        let bottomInset = self.view.safeAreaInsets.bottom
        ccPageSize.snp.makeConstraints { (make) -> Void in
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
