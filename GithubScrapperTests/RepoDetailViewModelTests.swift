//
//  RepoDetailViewModelTests.swift
//  GithubScrapperTests
//
//  Created by Nikita Rodin on 13.11.22.
//

import XCTest
@testable import GithubScrapper

final class RepoDetailViewModelTests: XCTestCase {

    private let api = MockGithubAPIImpl.shared
    private let repo = ScrappedRepo(name: "detail")
    private var viewModel: RepoDetailViewModel!

    override func setUpWithError() throws {
        api.source.removeAll()
        viewModel = RepoDetailViewModel()
    }

    override func tearDown() {
        viewModel = nil
    }

    func testLoadData() throws {
        api.source["detail"] = try Bundle.test.json(name: "detail")
        viewModel.loadData(scrappedRepo: repo)
        XCTAssertNotNil(viewModel.repo)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.errorAlert)
    }

    func testLoadDataFail() {
        viewModel.loadData(scrappedRepo: repo)
        XCTAssertNil(viewModel.repo)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssert(viewModel.errorAlert)
    }

    func testShortName() {
        XCTAssertEqual(viewModel.shortName(scrappedRepo: repo), "detail")
        XCTAssertEqual(viewModel.shortName(scrappedRepo: ScrappedRepo(name: "test/name")), "name")
    }

}
