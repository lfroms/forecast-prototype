//
//  WarningView.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2018-11-26.
//  Copyright © 2018 Lukas Romsicki. All rights reserved.
//

import Foundation
import SafariServices
import UIKit

struct WarningItem {
    let title: String
    let description: String?
    let priority: WarningPriority
    let type: WarningType
    let url: URL?
}

class WarningView: UIView, SFSafariViewControllerDelegate {
    @IBOutlet private var contentView: UIView!
    
    @IBOutlet private var iconLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var stack: UIStackView!
    
    @IBOutlet private var tapGestureRecognizer: UILongPressGestureRecognizer!
    
    private var url: URL?
    
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
            
            if contentView.bounds.contains(touchLocation) {
                presentSVCForURL()
            }
        default:
            break
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
    }
    
    // MARK: - Configuration
    
    func configure(with item: WarningItem) {
        contentView.backgroundColor =
            item.type == .ended
            ? WarningPriority.low.color
            : item.priority.color
        
        iconLabel.text = item.priority.iconName
        titleLabel.text = item.title.uppercased()
        
        url = item.url
        
        descriptionLabel.text = item.description
        descriptionLabel.isHidden = item.description?.isEmpty ?? true
    }
    
    // MARK: - Private Functions
    
    private func presentSVCForURL() {
        guard let url = url else {
            return
        }
        
        let svc = SFSafariViewController(url: url)
        svc.delegate = self
        
        UIApplication.shared.keyWindow?
            .rootViewController?
            .present(svc, animated: true, completion: nil)
    }
}
