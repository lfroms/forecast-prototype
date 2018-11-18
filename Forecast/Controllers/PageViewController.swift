//
//  PageViewController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-11-07.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation
import UIKit

class WeatherPageController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var pages = [UIViewController]()
    var pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        
        let p1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "CurrentConditions")
        let p2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "Forecast")
        
        pages.append(p1)
        pages.append(p2)
        
        setViewControllers([p1], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        
        configurePageControl()
    }
    
    func configurePageControl() {
        self.pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = 0
        self.pageControl.alpha = 1
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
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
    
    // MARK: Delegate functions
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = pages.index(of: pageContentViewController)!
    }
}
