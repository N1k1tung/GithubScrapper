//
//  XCUIElement+ext.swift
//  GithubScrapperUITests
//
//  Created by Nikita Rodin on 13.11.22.
//

import XCTest

extension XCUIElement {

    /// robust version of regular tap()
    func forceTap() {
        coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0)).tap()
    }

    /// waits for existance with default timeout
    func ensureExists(timeout: TimeInterval = 5.0) -> Bool {
        waitForExistence(timeout: timeout)
    }
}

extension XCUIApplication {
    /// back button on navigation bar
    var navigationBackButton: XCUIElement { navigationBars.buttons.element(boundBy: 0) }
}
