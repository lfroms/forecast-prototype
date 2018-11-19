//
//  PageViewController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-11-07.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation
import NightNight
import UIKit

class WeatherPageController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    var pages = [UIViewController]()
    var pageControl = UIPageControl()
    var mainVC: MainViewController?
    var currentPageIndex: Int = 0 {
        didSet(oldVal) {
            pageControl.currentPage = currentPageIndex
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        
        let p1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "CurrentConditions") as! CurrentConditionsViewController
        let p2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "Forecast") as! ForecastViewController
        
        pages.append(p1)
        pages.append(p2)
        
        setViewControllers([p1], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        
        configurePageControl()
        
        for subview in view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.delegate = self
            }
        }
    }
    
    func configurePageControl() {
        self.pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = currentPageIndex
        self.pageControl.alpha = 1
        self.pageControl.mixedTintColor = MixedColor(normal: .black, night: .white)
        self.pageControl.mixedPageIndicatorTintColor = MixedColor(normal: .lightGray, night: .darkGray)
        self.pageControl.mixedCurrentPageIndicatorTintColor = MixedColor(normal: .black, night: .white)
        self.view.addSubview(self.pageControl)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let cur = pages.index(of: viewController)!
        
        // Comment below to enable circular scrolling
        if cur == 0 { return nil }
        
        let prev = abs((cur - 1) % pages.count)
        return self.pages[prev]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let cur = pages.index(of: viewController)!
        
        // Comment below to enable circular scrolling
        if cur == (self.pages.count - 1) { return nil }
        
        let nxt = abs((cur + 1) % pages.count)
        return self.pages[nxt]
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        if completed {
            self.currentPageIndex = self.pages.index(of: pageContentViewController)!
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset
        var percentComplete: CGFloat
        percentComplete = abs(CGFloat(currentPageIndex) + (point.x - view.frame.size.width) / view.frame.size.width)
        
        if self.mainVC != nil {
            self.mainVC!.onTransitionProgress(percentComplete)
        }
    }
}
