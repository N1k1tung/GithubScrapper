//
//  GithubAPITests.swift
//  GithubAPITests
//
//  Created by Nikita Rodin on 12.11.22.
//

import XCTest
import Combine
@testable import GithubScrapper

final class GithubAPITests: XCTestCase, HasCancellables {

    var cancellables: Set<AnyCancellable> = []
    var githubAPI: GithubAPI = GithubAPIImpl()

    override func tearDownWithError() throws {
        cancellables = []
    }

    func testGetTrending() {
        let expectation = self.expectation(description: #function)

        githubAPI.getTrending()
            .sink {
                if case let .failure(error) = $0 {
                    XCTFail(error.localizedDescription)
                    expectation.fulfill()
                }
            } receiveValue: {
                XCTAssertFalse($0.isEmpty, "Repos should not be empty")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 10)
    }

    func testGetRepo() {
        let expectation = self.expectation(description: #function)

        githubAPI.getRepo(name: "github/mona-sans")
            .sink {
                if case let .failure(error) = $0 {
                    XCTFail(error.localizedDescription)
                    expectation.fulfill()
                }
            } receiveValue: {
                XCTAssertFalse($0.name.isEmpty, "Repo should have a name")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 10)
    }

    func testGetRepoFail() {
        let expectation = self.expectation(description: #function)

        githubAPI.getRepo(name: "invalid")
            .sink {
                if case .finished = $0 {
                    XCTFail("Should receive error")
                }
                else {
                    expectation.fulfill()
                }
            } receiveValue: { _ in
                XCTFail("Should receive error")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 10)
    }


}
