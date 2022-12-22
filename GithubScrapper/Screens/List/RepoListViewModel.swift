//
//  RepoListViewModel.swift
//  GithubScrapper
//
//  Created by Nikita Rodin on 12.11.22.
//

import Foundation
import SwiftUI
import Combine

final class RepoListViewModel: ObservableObject, HasCancellables, InjectGithubAPI {

    /// displayed repos
    @Published var repos: [ScrappedRepo] = []
    /// show loading error alert
    @Published var errorAlert = false
    /// loading state
    @Published var isLoading = false
    /// cancellables
    var cancellables: Set<AnyCancellable> = []

    /// loads data, shows alert on error, skips reload if data is already present, unless forced
    /// - Parameter forced: forced refresh
    func loadData(forced: Bool = false) {
        guard repos.isEmpty || forced else { return }
        isLoading = true

        githubAPI.getTrending()
            .sink { [weak self] in
                self?.isLoading = false
                if case let .failure(error) = $0 {
                    print(error)
                    self?.errorAlert = true
                }
            } receiveValue: { [weak self] in
                self?.isLoading = false
                self?.repos = $0
            }
            .store(in: &cancellables)
    }

}
