//
//  MockGithubAPI.swift
//  GithubScrapper
//
//  Created by Nikita Rodin on 13.11.22.
//

import Foundation
import Combine

/// mock API implementation for tests
class MockGithubAPIImpl: GithubAPI {

    static let shared = MockGithubAPIImpl()

    var source: [String: String]

    init(source: [String: String] = ProcessInfo.processInfo.environment) {
        self.source = source
    }

    func getTrending() -> any Publisher<[ScrappedRepo], Error> {
        fetch(path: "trending")
    }

    func getRepo(name: String) -> any Publisher<Repo, Error> {
        fetch(path: name)
    }

    /// fetch request from process environment
    /// - Parameter path: environment key
    /// - Returns: request publisher
    private func fetch<D: Decodable>(path: String) -> any Publisher<D, Error> {
        Just(source[path])
            .tryMap {
                guard let string = $0,
                      let data = string.data(using: .utf8) else { throw "No Data" }
                return data
            }
            .decode(type: D.self, decoder: decoder)
    }

    /// JSON decoder with date parsing
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

}
