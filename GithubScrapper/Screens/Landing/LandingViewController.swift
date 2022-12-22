//
//  LandingViewController.swift
//  GithubScrapper
//
//  Created by Nikita Rodin on 12.11.22.
//

import UIKit
import Combine

final class LandingViewController: UIViewController, HasCancellables {

    // outlets
    @IBOutlet private weak var privacyButton: UIButton!
    @IBOutlet private weak var termsButton: UIButton!
    @IBOutlet private weak var enterAppButton: GradientButton!
    @IBOutlet private weak var goToGithubButton: UIButton!

    /// view model
    var viewModel: LandingViewModel!
    /// cancellables
    var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind {
            privacyButton.tapped ~> viewModel.privacyTapped
            termsButton.tapped ~> viewModel.termsTapped
            enterAppButton.tapped ~> viewModel.enterAppTapped
            goToGithubButton.tapped ~> viewModel.goToGithubTapped

            NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification) ~> { [weak self] _ in
                self?.enterAppButton.playAnimation()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        enterAppButton.playAnimation()
    }

}
