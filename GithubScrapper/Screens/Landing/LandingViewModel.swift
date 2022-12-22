//
//  LandingViewModel.swift
//  GithubScrapper
//
//  Created by Nikita Rodin on 12.11.22.
//

import Foundation

final class LandingViewModel {

    enum NavigationEvent {
        case privacyPolicy
        case termsOfUse
        case goToGithub
        case enterApp
    }

    private var navigationHandler: (NavigationEvent) -> Void

    init(navigationHandler: @escaping (NavigationEvent) -> Void) {
        self.navigationHandler = navigationHandler
    }

    // MARK: actions

    func privacyTapped() {
        navigationHandler(.privacyPolicy)
    }

    func termsTapped() {
        navigationHandler(.termsOfUse)
    }

    func enterAppTapped() {
        navigationHandler(.enterApp)
    }

    func goToGithubTapped() {
        navigationHandler(.goToGithub)
    }

}
