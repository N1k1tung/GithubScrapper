//
//  Bundle+test.swift
//  GithubScrapperTests
//
//  Created by Nikita Rodin on 13.11.22.
//

import Foundation
import XCTest

extension Bundle {
    static var test: Bundle {
        Bundle(for: GithubAPITests.self)
    }

    func json(name: String) throws -> String {
        try String(contentsOf: try XCTUnwrap(url(forResource: name, withExtension: "json")))
    }
}
