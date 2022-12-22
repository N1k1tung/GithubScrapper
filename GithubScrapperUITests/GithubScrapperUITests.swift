//
//  GithubScrapperUITests.swift
//  GithubScrapperUITests
//
//  Created by Nikita Rodin on 12.11.22.
//

import XCTest

final class GithubScrapperUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchEnvironment["UITest"] = "true"
    }

    /// opens trending project with mocked service and checks every project details
    func testViewDetail() throws {
        let trending = try Bundle.test.json(name: "trending")
        let detail = try Bundle.test.json(name: "detail")
        app.launchEnvironment["trending"] = trending
        let data = try XCTUnwrap(trending.data(using: .utf8))
        let repos = try JSONDecoder().decode([ScrappedRepo].self, from: data)
        repos.forEach { app.launchEnvironment[$0.name] = detail }
        app.launch()
        let enterButton = app.buttons["Enter the app"]
        let trendingTitle = app.navigationBars.staticTexts["Trending Projects"]
        XCTAssert(enterButton.ensureExists())
        XCTContext.runActivity(named: "when tapping Enter app") { _ in
            enterButton.tap()
            XCTContext.runActivity(named: "should open trending projects") { _ in
                XCTAssert(trendingTitle.ensureExists())
                for repo in repos {
                    openDetail(repo: repo)
                }
            }
        }
    }

    // opens repo detail, opens browser link within and goes back
    private func openDetail(repo: ScrappedRepo) {
        let row = app.staticTexts[repo.name]
        let detailDescription = app.staticTexts["Rembg is a tool to remove images background."]
        let link = "https://mock.test"
        let linkTitle = "mock.test"
        XCTContext.runActivity(named: "when tapping \(repo.name)") { _ in
            row.tap()
            XCTContext.runActivity(named: "should open repo detail") { _ in
                XCTAssert(detailDescription.ensureExists())

                openBrowserWith(button: link, siteName: linkTitle)

                XCTContext.runActivity(named: "and then return to trending projects") { _ in
                    app.navigationBackButton.tap()
                }
            }
        }
    }

    /// opens every link on landing screen with mocked configuration
    func testViewLinks() throws {
        let links = [
            "mainUrl": "Go to Github",
            "termsUrl": "Terms of Use",
            "privacyUrl": "Privacy Policy",
        ]
        links.keys.forEach { app.launchEnvironment[$0] = "https://\($0)" }
        app.launch()
        for (link, button) in links {
            openBrowserWith(button: button, siteName: link)
        }
    }

    // opens browser clicking specified button, checks that expected link is loaded and goes back
    private func openBrowserWith(button name: String, siteName: String) {
        let button = app.buttons[name]
        let browserBar = app.otherElements["TopBrowserBar"]
        let title = browserBar.otherElements["URL"]
        let doneButton = browserBar.buttons["Done"]
        XCTAssert(button.ensureExists())
        XCTContext.runActivity(named: "when tapping \(name)", block: { _ in
            button.tap()
            XCTContext.runActivity(named: "should open corresponding link in app browser") { _ in
                XCTAssert(browserBar.ensureExists())
                XCTAssert(title.ensureExists())
                // title contains extra unreadable characters hence check for contains
                XCTAssert((title.value as? String)?.contains(siteName.lowercased()) == true)
                XCTContext.runActivity(named: "and then return") { _ in
                    XCTAssert(doneButton.isHittable)
                    doneButton.forceTap()
                    XCTAssert(button.ensureExists())
                }
            }
        })
    }

}
