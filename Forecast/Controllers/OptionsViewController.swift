//
//  OptionsViewController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-12-26.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation
import SwiftDate
import UIKit

class OptionsViewController: UIViewController, UIScrollViewDelegate, UISearchBarDelegate {
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var forecastDateLabel: UILabel!
    @IBOutlet var searchField: UISearchBar!
    @IBOutlet var searchContainer: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var locationView: UIView!
    @IBOutlet var forecastIssueView: UIView!

    var initialSearchContainerY: CGFloat = 0

    var resultsController: SearchTableViewController?

    override func viewDidLoad() {
        scrollView.delegate = self
        searchField.delegate = self
    }

    override func viewDidLayoutSubviews() {
        let textFieldInsideSearchBar = searchField.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white

        let site = defaultSite()
        guard site != nil else {
            return
        }

        let query = WeatherQuery(region: site!.region, code: site!.code)

        apollo.fetch(query: query, cachePolicy: .returnCacheDataElseFetch) { result, _ in
            let data = result?.data?.weather

            if let location = data?.currentConditions.station?.value, location != "" {
                self.locationLabel.text = data?.currentConditions.station?.value
            } else {
                self.locationView.isHidden = true
            }

            if let timestamp = data?.forecastGroup.dateTime?.timeStamp, timestamp != "" {
                self.forecastDateLabel.text = timestamp
                    .toDate("yyyyMMddHHmmss", region: .UTC)?
                    .convertTo(region: .current)
                    .toFormat("MMM d 'at' h:mm a", locale: Locales.current)
            } else {
                self.forecastIssueView.isHidden = true
            }

            self.initialSearchContainerY = self.searchContainer.frame.minY
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchContainer.frame.origin.y = max(initialSearchContainerY, scrollView.contentOffset.y)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resultsController?.updateSearchResults(searchText)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        scrollView.scrollToView(view: searchContainer, animated: true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let childViewController = segue.destination as? SearchTableViewController {
            childViewController.view.translatesAutoresizingMaskIntoConstraints = false
            resultsController = childViewController
        }
    }

    @IBAction func returnToMain(_ button: UIButton) {
        dismiss(animated: true)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}

@IBDesignable
class CitySearchField: UITextField {
    @IBInspectable var paddingLeft: CGFloat = 0
    @IBInspectable var paddingRight: CGFloat = 0

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(
            x: bounds.origin.x + paddingLeft,
            y: bounds.origin.y,
            width: bounds.size.width - paddingLeft - paddingRight,
            height: bounds.size.height
        )
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}

extension UIScrollView {
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view: UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            scrollRectToVisible(
                CGRect(
                    x: 0,
                    y: childStartPoint.y,
                    width: 1,
                    height: frame.height
                ),
                animated: animated
            )
        }
    }
}
