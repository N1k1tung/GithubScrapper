//
//  Bundle+test.swift
//  GithubScrapperUITests
//
//  Created by Nikita Rodin on 13.11.22.
//

import Foundation
import XCTest

extension Bundle {
    static var test: Bundle {
        Bundle(for: GithubScrapperUITests.self)
    }

    func json(name: String) throws -> String {
        try String(contentsOf: try XCTUnwrap(url(forResource: name, withExtension: "json")))
    }
}
