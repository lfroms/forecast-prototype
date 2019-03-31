//
//  HeaderView.swift
//  Forecast
//
//  Created by Lukas Romsicki on 2019-03-30.
//  Copyright © 2019 Lukas Romsicki. All rights reserved.
//

import Foundation
import UIKit

class HeaderView: UIView {
    @IBOutlet private var contentView: UIView!

    @IBOutlet private var statusBarBackdrop: UIVisualEffectView!
    @IBOutlet private var warningsContainer: StyledView!
    @IBOutlet private var warningsStack: UIStackView!

    private var headerAnimator: UIViewPropertyAnimator?

    var warnings: [WarningItem] = [] {
        didSet {
            warningsStack.subviews.forEach({ $0.removeFromSuperview() })
            renderWarnings()
        }
    }

    var animationProgress: CGFloat? {
        get { return headerAnimator?.fractionComplete }
        set {
            guard let fraction = newValue, warnings.isEmpty else {
                return
            }

            headerAnimator?.fractionComplete = fraction
        }
    }

    var warningsHeight: CGFloat {
        return warningsContainer.frame.height
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

    override func awakeFromNib() {
        statusBarBackdrop.effect = nil
        headerAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
            self.statusBarBackdrop.effect = UIBlurEffect(style: .light)
        }

        headerAnimator?.pausesOnCompletion = true
    }

    private func renderWarnings() {
        for warning in warnings {
            let view = WarningView()
            view.configure(with: warning)

            warningsStack.addArrangedSubview(view)
            warningsStack.layoutIfNeeded()
        }

        statusBarBackdrop.backgroundColor = warnings.first?.priority.color
    }
}
