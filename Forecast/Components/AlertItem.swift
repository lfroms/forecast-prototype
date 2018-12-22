//
//  AlertItem.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-11-26.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation
import UIKit

class AlertItem: UIView {
    @IBOutlet var contentView: AlertItem!
    
    @IBOutlet var backdrop: UIStyledView!
    @IBOutlet var iconLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    var url: URL?
    
    @IBAction func didPerformTapGesture(_ sender: UITapGestureRecognizer) {
        if url != nil {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("AlertItem", owner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    override var intrinsicContentSize: CGSize {
        return contentView.frame.size
    }
    
    func with(icon: String, title: String, description: String?, priority: AlertPriority?, url: String?) -> AlertItem {
        backdrop.backgroundColor = getColorForPriority(priority)
        iconLabel.text = icon
        titleLabel.text = title
        
        self.url = URL(string: url ?? "")
        
        if description != nil && description != "" {
            descriptionLabel.text = description
        } else {
            descriptionLabel.isHidden = true
        }
        
        invalidateIntrinsicContentSize()
        
        return self
    }
    
    private func getColorForPriority(_ priority: AlertPriority?) -> UIColor {
        switch priority {
        case .low?:
            return UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 1.0)
        case .medium?:
            return UIColor(red: 1.00, green: 0.92, blue: 0.00, alpha: 1.0)
        case .high?:
            return UIColor(red: 0.96, green: 0.26, blue: 0.21, alpha: 1.0)
        default:
            return UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 1.0)
        }
    }
}
