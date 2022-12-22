//
//  RevealAnimator.swift
//  GithubScrapper
//
//  Created by Nikita Rodin on 12.11.22.
//

import UIKit

/// reveals destination with circular mask starting from specified frame
final class RevealAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private let initialFrame: CGRect

    init(initialFrame: CGRect) {
        self.initialFrame = initialFrame
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)

        toController.view.frame = containerView.bounds
        containerView.insertSubview(toController.view, aboveSubview: fromController.view)

        let initialPath = UIBezierPath(ovalIn: initialFrame)

        let finalSize = max(toController.view.bounds.width, toController.view.bounds.height)
        let finalPath = UIBezierPath(ovalIn: initialFrame.insetBy(dx: -finalSize, dy: -finalSize))

        let maskLayer = CAShapeLayer()
        toController.view.layer.mask = maskLayer

        // stretch the mask layer
        let revealAnimation = CABasicAnimation(keyPath: "path")
        revealAnimation.fromValue = initialPath.cgPath
        revealAnimation.toValue = finalPath.cgPath
        revealAnimation.duration = duration+0.05
        maskLayer.add(revealAnimation, forKey: "path")

        // cancel out just before it finishes to avoid blinking
        DispatchQueue.main.asyncAfter(deadline: .now()+duration) {
            fromController.view.removeFromSuperview()
            toController.view.layer.mask = nil
            transitionContext.completeTransition(true)
        }
    }

}
