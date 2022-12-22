//
//  RepoDetailCoordinator.swift
//  GithubScrapper
//
//  Created by Nikita Rodin on 12.11.22.
//

import SwiftUI
import SafariServices

final class RepoDetailCoordinator: SwiftUICoordinator {

    /// scrapped repo
    private let repo: ScrappedRepo
    /// presentation context
    private weak var context: UIViewController?

    init(repo: ScrappedRepo, context: UIViewController?) {
        self.repo = repo
        self.context = context
    }

    var rootView: some View {
        RepoDetailView(repo: repo, openURLAction: OpenURLAction(handler: { url in
            let viewController = SFSafariViewController(url: url)
            self.context?.present(viewController, animated: true)
            return .handled
        }))
    }

}
