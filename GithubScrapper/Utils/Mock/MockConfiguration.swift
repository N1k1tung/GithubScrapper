//
//  MockConfiguration.swift
//  GithubScrapper
//
//  Created by Nikita Rodin on 13.11.22.
//

import Foundation

/// mock confirguration implementation for UI tests
final class MockConfiguration: LandingCoordinatorConfiguration {

    @MockConfigurationKey("mainUrl")
    var mainUrl: String

    @MockConfigurationKey("termsUrl")
    var termsUrl: String

    @MockConfigurationKey("privacyUrl")
    var privacyUrl: String

}

/// property wrapper for mock configuration from process environment
@propertyWrapper
class MockConfigurationKey<T> {
    private let key: String

    init(_ key: String) {
        self.key = key
    }

    var wrappedValue: T {
        ProcessInfo.processInfo.environment[key] as! T
    }
}
