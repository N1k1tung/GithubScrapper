//
//  GihubAPI.swift
//  GithubScrapper
//
//  Created by Nikita Rodin on 12.11.22.
//

import Foundation
import Combine

protocol GithubAPIConfiguration {
    var githubTrendingUrl: String { get }
    var githubApiUrl: String { get }
    var githubToken: String { get }
}
extension Configuration: GithubAPIConfiguration {}

protocol GithubAPI {
    func getTrending() -> any Publisher<[ScrappedRepo], Error>
    func getRepo(name: String) -> any Publisher<Repo, Error>
}

struct GithubAPIImpl: GithubAPI {

    let configuration: GithubAPIConfiguration

    init(configuration: GithubAPIConfiguration = Configuration.shared) {
        self.configuration = configuration
    }

    /// since github doesn't provide trending API or options in search API to fetch trending or recent stars
    /// this just scraps configured trending webpage
    /// - Returns: trending repos
    func getTrending() -> any Publisher<[ScrappedRepo], Error> {
        guard let url = URL(string: configuration.githubTrendingUrl) else {
            return Fail(error: "Invalid configured URL")
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .retry(3)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse,
                      200...209 ~= httpResponse.statusCode,
                      let html = String(data: data, encoding: .utf8) else { throw "Request failed" }
                let regexp = try NSRegularExpression(pattern: "\"\\/(.+?\\/.+?)\\/stargazers\"")
                var repos = [ScrappedRepo]()
                let matches = regexp.matches(in: html, range: NSRange(location: 0, length: html.count))
                for match in matches {
                    if match.numberOfRanges > 1,
                       let range = Range(match.range(at: 1), in: html) {
                        let name = String(html[range])
                        repos.append(ScrappedRepo(name: name))
                    }
                }
                return repos
            }
            .receive(on: DispatchQueue.main)
    }

    /// gets repo by scrapped repo name
    /// - Parameter name: scrapped repo name
    /// - Returns: repo info
    func getRepo(name: String) -> any Publisher<Repo, Error> {
        guard var url = URL(string: configuration.githubApiUrl) else {
            return Fail(error: "Invalid configured URL")
        }
        url = url.appendingPathComponent("repos")
            .appendingPathComponent(name)
        var request = URLRequest(url: url)
        if !configuration.githubToken.isEmpty {
            request.setValue("Bearer \(configuration.githubToken)", forHTTPHeaderField: "Authorization")
        }
        return URLSession.shared.dataTaskPublisher(for: request)
            .retry(3)
            .map(\.data)
            .decode(type: Repo.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
    }

    /// JSON decoder with date parsing
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

}

protocol InjectGithubAPI {
    var githubAPI: GithubAPI { get }
}

extension InjectGithubAPI {
    var githubAPI: GithubAPI {
        #if DEBUG
        ProcessInfo.isUITest || ProcessInfo.isUnitTest ? MockGithubAPIImpl.shared : GithubAPIImpl()
        #else
        GithubAPIImpl()
        #endif
    }
}
