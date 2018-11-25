//
//  SearchViewController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-11-25.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Siesta
import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {
    var sites: [Site]?
    var filteredSites: [Site]?
    var selectedSiteIndex: Int?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnvCanada.shared.siteList.addObserver(self)
        EnvCanada.shared.siteList.loadIfNeeded()
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
    }
    
    @IBAction func exit(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func setResults() {
        let resource = EnvCanada.shared.siteList
        
        if let data = resource.latestData?.content as! [Site]?, resource.isLoading == false {
            sites = data
            filteredSites = data
            
            tableView.reloadData()
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
        searchController.dismiss(animated: false, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty, sites != nil {
            filteredSites = sites!.filter { site in
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
            searchController.dismiss(animated: false, completion: nil)
            
            filteredSites?[indexPath.row].saveAsDefault()
            EnvCanada.shared.siteData(in: .English).load()
            
            dismiss(animated: true, completion: nil)
        }
    }
}

extension SearchTableViewController: ResourceObserver {
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        setResults()
    }
}
