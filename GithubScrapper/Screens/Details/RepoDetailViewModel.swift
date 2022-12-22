//
//  RepoDetailViewModel.swift
//  GithubScrapper
//
//  Created by Nikita Rodin on 12.11.22.
//

import Foundation
import Combine
import SwiftUI

final class RepoDetailViewModel: ObservableObject, HasCancellables, InjectGithubAPI {

    /// repo info
    @Published var repo: Repo?
    /// show loading error alert
    @Published var errorAlert = false
    /// loading state
    @Published var isLoading = false
    /// cancellables
    var cancellables: Set<AnyCancellable> = []

    /// loads details of the repo, shows alert on error
    /// - Parameter scrappedRepo: scrapped repo
    func loadData(scrappedRepo: ScrappedRepo) {
        isLoading = true

        githubAPI.getRepo(name: scrappedRepo.name)
            .sink { [weak self] in
                self?.isLoading = false
                if case let .failure(error) = $0 {
                    print(error)
                    self?.errorAlert = true
                }
            } receiveValue: { [weak self] in
                self?.isLoading = false
                self?.repo = $0
            }
            .store(in: &cancellables)
    }

    /// just the name of the repository without the owner
    /// - Parameter scrappedRepo: scrapped repo
    /// - Returns: short name
    func shortName(scrappedRepo: ScrappedRepo) -> String {
        scrappedRepo.name.split(separator: "/").map(String.init).last ?? scrappedRepo.name
    }

}
