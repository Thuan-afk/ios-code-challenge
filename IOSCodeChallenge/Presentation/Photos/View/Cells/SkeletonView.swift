//
//  SkeletonView.swift
//  IOSCodeChallenge
//
//  Created by Hoa Thuan on 02/10/2025.
//

import UIKit

class SkeletonView: UIView {
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .white
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = [
            UIColor.lightGray.withAlphaComponent(0.3).cgColor,
            UIColor.lightGray.withAlphaComponent(0.6).cgColor,
            UIColor.lightGray.withAlphaComponent(0.3).cgColor
        ]
        gradientLayer.locations = [0, 0.5, 1]
        layer.addSublayer(gradientLayer)

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1]
        animation.duration = 1.2
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmer")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
