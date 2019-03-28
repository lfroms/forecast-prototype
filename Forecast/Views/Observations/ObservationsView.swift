//
//  ObservationsView.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-27.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import UIKit

class ObservationsView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet var contentView: UIView!
    @IBOutlet private var collectionView: UICollectionView!
    
    var dataSourceItems: [ObservationItem] = [] {
        didSet {
            collectionView.reloadData()
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
    
    func commonInit() {
        let className = String(describing: type(of: self))
        Bundle.main.loadNibNamed(className, owner: self, options: nil)
        contentView.fixInView(self, followsLayoutMargins: false)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            ObservationView.self,
            forCellWithReuseIdentifier: ObservationView.getClassName()
        )
    }
    
    // MARK: - CollectionView Implementation
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourceItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ObservationView.getClassName(),
            for: indexPath
        ) as! ObservationView
        
        cell.configure(with: dataSourceItems[indexPath.row])
        return cell
    }
}
