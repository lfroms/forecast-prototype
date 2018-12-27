//
//  SearchViewController.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-11-25.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Siesta
import UIKit

class SearchTableViewController: UITableViewController {
    var sites: [Site]?
    var filteredSites: [Site]?
    var selectedSiteIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EnvCanada.shared.siteList.addObserver(self)
        EnvCanada.shared.siteList.loadIfNeeded()
    }
    
    @IBAction func exit(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func setResults() {
        let resource = EnvCanada.shared.siteList
        
        if let data = resource.latestData?.content as! [Site]?, resource.isLoading == false {
            sites = data.filter({ $0.provinceCode != "HEF" })
            filteredSites = sites
            
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
    }
    
    func updateSearchResults(_ searchText: String) {
        if !searchText.isEmpty, sites != nil {
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
            
            filteredSites?[indexPath.row].saveAsDefault()
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "resetObservers"), object: nil))
            
            dismiss(animated: true, completion: nil)
        }
    }
}

extension SearchTableViewController: ResourceObserver {
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        setResults()
    }
}

class SelfSizedTableView: UITableView {
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    override func reloadData() {
        super.reloadData()
        invalidateIntrinsicContentSize()
        layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        let height = max(contentSize.height, maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }
}
