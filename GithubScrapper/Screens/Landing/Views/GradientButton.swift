//
//  GradientButton.swift
//  GithubScrapper
//
//  Created by Nikita Rodin on 13.11.22.
//

import UIKit

/// button with attract animation
class GradientButton: UIButton {

    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }
    var gradientLayer: CAGradientLayer {
        layer as! CAGradientLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let background = UIColor(red: 0.99, green: 0.39, blue: 0.29, alpha: 1)
        let colors = [
            background.withAlphaComponent(0.2),
            UIColor.white.withAlphaComponent(0.2),
            background.withAlphaComponent(0.2)
        ].compactMap { $0?.cgColor }
        gradientLayer.colors = colors
        gradientLayer.locations = [-0.4, -0.2, 0.0].map { $0 as NSNumber }
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.backgroundColor = background.cgColor
    }

    func playAnimation() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-0.5, -0.25, 0.0]
        animation.toValue = [1.0, 1.25, 1.5]
        animation.duration = 0.7
        let group = CAAnimationGroup()
        group.animations = [animation]
        group.duration = 3.0
        group.repeatCount = .infinity
        gradientLayer.add(group, forKey: nil)
    }

}
