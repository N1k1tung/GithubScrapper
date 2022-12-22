//
//  Configuration.swift
//  GithubScrapper
//
//  Created by Nikita Rodin on 12.11.22.
//

import Foundation

/// A helper class to get the configuration data from the plist file
final class Configuration {

    fileprivate var dict = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Configuration", ofType: "plist")!)

    static let shared = Configuration()

    @ConfigurationKey("mainUrl")
    var mainUrl: String

    @ConfigurationKey("termsUrl")
    var termsUrl: String

    @ConfigurationKey("privacyUrl")
    var privacyUrl: String

    @ConfigurationKey("githubTrendingUrl")
    var githubTrendingUrl: String

    @ConfigurationKey("githubApiUrl")
    var githubApiUrl: String

    @ConfigurationKey("githubToken")
    var githubToken: String
}

/// property wrapper for configuration keys
@propertyWrapper
class ConfigurationKey<T> {
    private let key: String

    init(_ key: String) {
        self.key = key
    }

    var wrappedValue: T {
        Configuration.shared.dict![key] as! T
    }
}
