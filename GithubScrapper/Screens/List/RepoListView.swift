//
//  RepoListView.swift
//  GithubScrapper
//
//  Created by Nikita Rodin on 12.11.22.
//

import SwiftUI

struct RepoListView<Desination: View>: View {

    /// navigation link
    let navigateToDetail: (ScrappedRepo, () -> Text) -> NavigationLink<Text, Desination>?
    /// on close
    let closeTapped: () -> Void

    /// view model
    @StateObject var viewModel = RepoListViewModel()

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                VStack {
                    ProgressView()
                    Text("Loading...")
                }
            }
            else {
                List(viewModel.repos) { repo in
                    navigateToDetail(repo) {
                        Text(repo.name)
                    }
                }
                .listStyle(.plain)
            }
        }
        .refreshable {
            viewModel.loadData(forced: true)
        }
        .onAppear {
            viewModel.loadData()
        }
        .alert("Error loading trending projects", isPresented: $viewModel.errorAlert) {
            Button("OK", role: .cancel) { }
        }
        .navigationTitle("Trending Projects")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Close", action: closeTapped)
            }
        }
    }
}
