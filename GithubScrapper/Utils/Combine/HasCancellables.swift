//
//  HasCancellables.swift
//  GithubScrapper
//
//  Created by Nikita Rodin on 12.11.22.
//

import Combine

/// for objects with lifetime cancellables
protocol HasCancellables: AnyObject {
    var cancellables: Set<AnyCancellable> { get set }
}
