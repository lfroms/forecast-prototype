//
//  HourlyForecasts.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-29.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation
import UIKit

class HourlyForecastsView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var unavailableLabel: UILabel!
    
    var dataSourceItems: [HourlyForecastItem] = [] {
        didSet {
            collectionView.reloadData()
            unavailableLabel.isHidden = dataSourceItems.count > 0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let className = String(describing: type(of: self))
        Bundle.main.loadNibNamed(className, owner: self, options: nil)
        contentView.fixInView(self, followsLayoutMargins: false)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            HourlyForecastView.self,
            forCellWithReuseIdentifier: HourlyForecastView.getClassName()
        )
    }
    
    // MARK: - CollectionView Implementation
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourceItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HourlyForecastView.getClassName(),
            for: indexPath
        ) as! HourlyForecastView
        
        cell.configure(with: dataSourceItems[indexPath.row])
        return cell
    }
}
