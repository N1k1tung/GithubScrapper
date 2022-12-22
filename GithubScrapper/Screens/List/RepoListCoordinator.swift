//
//  RepoListCoordinator.swift
//  GithubScrapper
//
//  Created by Nikita Rodin on 12.11.22.
//

import SwiftUI
import UIKit

final class RepoListCoordinator: FlowCoordinator, SwiftUICoordinator {

    /// presentation context
    private var context = UIViewController()

    init() {
        let viewController = UIHostingController(rootView: rootView)
        viewController.modalPresentationStyle = .fullScreen
        context = viewController
    }

    var rootViewController: UIViewController {
        context
    }

    var rootView: some View {
        NavigationView {
            RepoListView { repo, label in
                NavigationLink(destination: {
                    RepoDetailCoordinator(repo: repo, context: self.context).rootView
                }, label: label)
            } closeTapped: {
                self.context.dismiss(animated: true)
            }
        }
        .navigationViewStyle(.stack)
    }

}

