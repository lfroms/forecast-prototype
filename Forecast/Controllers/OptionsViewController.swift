//
//  OptionsViewController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-12-26.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation
import Siesta
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
        let resource = EnvCanada.shared.siteData

        if let data = resource.latestData?.content as! SiteData?,
            resource.isLoading == false {
            if let location = data.currentConditions?.station?.value, location != "" {
                locationLabel.text = data.currentConditions?.station?.value
            } else {
                locationView.isHidden = true
            }

            if let timestamp = data.forecastGroup?.dateTime
                .first(where: { $0.zone == "UTC" })?.value.timeStamp, timestamp != "" {
                forecastDateLabel.text = timestamp
                    .toDate("yyyyMMddHHmmss", region: .UTC)?
                    .convertTo(region: .current)
                    .toFormat("MMM d 'at' h:mm a", locale: Locales.current)
            } else {
                forecastIssueView.isHidden = true
            }

            initialSearchContainerY = searchContainer.frame.minY
        }

        let textFieldInsideSearchBar = searchField.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchContainer.frame.origin.y = max(initialSearchContainerY, scrollView.contentOffset.y)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resultsController?.updateSearchResults(searchText)
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
        return CGRect(x: bounds.origin.x + paddingLeft, y: bounds.origin.y, width: bounds.size.width - paddingLeft - paddingRight, height: bounds.size.height)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}
