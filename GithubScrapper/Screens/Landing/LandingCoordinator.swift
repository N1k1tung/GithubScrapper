//
//  LandingCoordinator.swift
//  GithubScrapper
//
//  Created by Nikita Rodin on 12.11.22.
//

import UIKit
import SafariServices

protocol LandingCoordinatorConfiguration {
    var mainUrl: String { get }
    var termsUrl: String { get }
    var privacyUrl: String { get }
}
extension Configuration: LandingCoordinatorConfiguration {}

final class LandingCoordinator: NSObject, FlowCoordinator {

    private let configuration: LandingCoordinatorConfiguration

    init(configuration: LandingCoordinatorConfiguration = Configuration.shared) {
        self.configuration = configuration
        super.init()
    }

    var rootViewController: UIViewController {
        let vc = LandingViewController.instantiate()
        vc.viewModel = LandingViewModel { [weak vc] in
            switch $0 {
            case .goToGithub:
                self.open(url: self.configuration.mainUrl, from: vc)
            case .privacyPolicy:
                self.open(url: self.configuration.privacyUrl, from: vc)
            case .termsOfUse:
                self.open(url: self.configuration.termsUrl, from: vc)
            case .enterApp:
                self.proceedToApp(from: vc)
            }
        }
        return vc
    }

    /// opens url in SafariViewController
    /// - Parameters:
    ///   - url: the url
    ///   - from: presenting view controller
    private func open(url: String, from: UIViewController?) {
        guard let url = URL(string: url) else {
            let alert = UIAlertController(title: nil, message: "Invalid configured URL", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            from?.present(alert, animated: true, completion: nil)
            return
        }
        let viewController = SFSafariViewController(url: url)
        from?.present(viewController, animated: true)
    }

    /// opens repo list
    /// - Parameter from: presenting view controller
    private func proceedToApp(from: UIViewController?) {
        let toVC = RepoListCoordinator().rootViewController
        toVC.transitioningDelegate = self
        from?.present(toVC, animated: true)
    }

}

/// custom present/dismiss transition
extension LandingCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        RevealAnimator(initialFrame: CGRect(x: presenting.view.bounds.midX - 20, y: presenting.view.bounds.midY - 20, width: 40, height: 40))
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        RevealAnimator(initialFrame: CGRect(x: dismissed.view.bounds.midX - 20, y: dismissed.view.bounds.midY - 20, width: 40, height: 40))
    }
}
