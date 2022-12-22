//
//  RepoListViewModelTests.swift
//  GithubScrapperTests
//
//  Created by Nikita Rodin on 13.11.22.
//

import XCTest
@testable import GithubScrapper

final class RepoListViewModelTests: XCTestCase {

    private let api = MockGithubAPIImpl.shared
    private var viewModel: RepoListViewModel!

    override func setUpWithError() throws {
        api.source.removeAll()
        viewModel = RepoListViewModel()
    }

    override func tearDown() {
        viewModel = nil
    }

    func testLoadData() throws {
        api.source["trending"] = try Bundle.test.json(name: "trending")
        viewModel.loadData()
        XCTAssert(viewModel.repos.count == 6)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.errorAlert)
    }

    func testLoadDataForced() throws {
        api.source["trending"] = try Bundle.test.json(name: "trending")
        var loadingValues = [Bool]()
        let loading = viewModel.$isLoading
            .sink {
                loadingValues.append($0)
            }
        viewModel.loadData()
        XCTAssertFalse(viewModel.isLoading)
        XCTAssert(loadingValues.contains(true))
        loadingValues = []
        viewModel.loadData()
        XCTAssertFalse(loadingValues.contains(true), "Should not load again")
        loadingValues = []
        viewModel.loadData(forced: true)
        XCTAssert(loadingValues.contains(true), "Should load again")
        loading.cancel()
    }

    func testLoadDataFail() {
        viewModel.loadData()
        XCTAssert(viewModel.repos.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssert(viewModel.errorAlert)
    }


}
