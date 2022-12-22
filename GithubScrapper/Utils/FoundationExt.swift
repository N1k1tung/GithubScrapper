//
//  FoundationExt.swift
//  GithubScrapper
//
//  Created by Nikita Rodin on 12.11.22.
//

import Foundation

/// allows throwing strings
extension String: Error {}

/// class name
extension NSObject {
    static var className: String {
        return String(describing: self)
    }
    var className: String {
        return String(describing: type(of: self))
    }
}

/// detects UI tests
extension ProcessInfo {
    static var isUITest: Bool {
        processInfo.environment["UITest"] == "true"
    }
    static var isUnitTest: Bool {
        processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}
