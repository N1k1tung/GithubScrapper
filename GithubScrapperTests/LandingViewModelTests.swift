//
//  LandingViewModelTests.swift
//  GithubScrapperTests
//
//  Created by Nikita Rodin on 13.11.22.
//

import XCTest
@testable import GithubScrapper

final class LandingViewModelTests: XCTestCase {

    private var viewModel: LandingViewModel!
    private var event: LandingViewModel.NavigationEvent?

    override func setUp() {
        viewModel = LandingViewModel {
            self.event = $0
        }
    }
    override func tearDown() {
        viewModel = nil
    }

    func testPrivacyTap() {
        viewModel.privacyTapped()
        XCTAssert(event == .privacyPolicy)
    }

    func testTermsTap() {
        viewModel.termsTapped()
        XCTAssert(event == .termsOfUse)
    }

    func testEnterAppTap() {
        viewModel.enterAppTapped()
        XCTAssert(event == .enterApp)
    }

    func testGoToGithubTap() {
        viewModel.goToGithubTapped()
        XCTAssert(event == .goToGithub)
    }

}
