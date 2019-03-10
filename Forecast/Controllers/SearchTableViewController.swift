//
//  SearchViewController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-11-25.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    var sites: [SiteListQuery.Data.Site]?
    var filteredSites: [SiteListQuery.Data.Site]?
    var selectedSiteIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setResults()
    }
    
    @IBAction func exit(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func setResults() {
        apollo.fetch(query: SiteListQuery(), cachePolicy: .returnCacheDataElseFetch) { result, _ in
            let sites = result?.data?.sites
            self.sites = sites
            self.filteredSites = sites
            
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let siteList = filteredSites else {
            return 0
        }
        
        return siteList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        
        if let siteList = filteredSites {
            let site = siteList[indexPath.row]
            cell.textLabel!.text = site.nameEn
            cell.detailTextLabel!.text = site.provinceCode
        }
        
        cell.accessoryType = .none
        if let selectedSiteIndex = self.selectedSiteIndex {
            if indexPath.row == selectedSiteIndex {
                cell.accessoryType = .checkmark
            }
        }
        
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func updateSearchResults(_ searchText: String) {
        if !searchText.isEmpty, sites != nil {
            filteredSites = sites?.filter { site in
                site.nameEn.lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredSites = sites
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) != nil {
            view.endEditing(true)
            
            filteredSites?[indexPath.row].saveAsDefault()
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "resetObservers"), object: nil))
            
            dismiss(animated: true, completion: nil)
        }
    }
}

class SelfSizedTableView: UITableView {
    override func reloadData() {
        super.reloadData()
        invalidateIntrinsicContentSize()
        layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
