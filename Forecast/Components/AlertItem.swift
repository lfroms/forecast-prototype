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
    @IBOutlet var stack: UIStackView!
    
    @IBOutlet var tapGestureRecognizer: UILongPressGestureRecognizer!
    
    var url: URL?
    
    @IBAction func didPerformTapGesture(_ sender: UILongPressGestureRecognizer) {
        let touchLocation = sender.location(in: contentView)
        
        switch sender.state {
        case .began:
            UIView.animate(withDuration: 0.06) {
                self.iconLabel.alpha = 0.4
                self.stack.alpha = 0.4
            }
        case .changed:
            if !contentView.bounds.contains(touchLocation) {
                UIView.animate(withDuration: 0.3) {
                    self.iconLabel.alpha = 1
                    self.stack.alpha = 1
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.iconLabel.alpha = 0.4
                    self.stack.alpha = 0.4
                }
            }
        case .ended:
            UIView.animate(withDuration: 0.3) {
                self.iconLabel.alpha = 1
                self.stack.alpha = 1
            }
            
            if contentView.bounds.contains(touchLocation), url != nil {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
            
        default:
            break
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
    
    func with(icon: String, title: String, description: String?, priority: WarningPriority?, url: String?) -> AlertItem {
        backdrop.backgroundColor = getColorForAlertPriority(priority)
        iconLabel.text = icon
        titleLabel.text = title.uppercased()
        
        self.url = URL(string: url ?? "")
        
        if description != nil, description != "" {
            descriptionLabel.text = description
        } else {
            descriptionLabel.isHidden = true
        }
        
        invalidateIntrinsicContentSize()
        
        return self
    }
}

func getColorForAlertPriority(_ priority: WarningPriority?) -> UIColor {
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
