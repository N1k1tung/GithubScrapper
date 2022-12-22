//
//  RepoDetailView.swift
//  GithubScrapper
//
//  Created by Nikita Rodin on 12.11.22.
//

import SwiftUI

struct RepoDetailView: View {
    /// view model
    @StateObject var viewModel = RepoDetailViewModel()
    /// scrapped repo to display
    let repo: ScrappedRepo
    /// open link action
    let openURLAction: OpenURLAction

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                VStack {
                    ProgressView()
                    Text("Loading...")
                }
            }
            else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        if let repo = viewModel.repo {
                            if let urlString = repo.htmlURL,
                                let url = URL(string: urlString) {
                                Text("URL:")
                                    .fontWeight(.bold)
                                Link(urlString, destination: url)
                                    .environment(\.openURL, openURLAction)
                            }
                            if let description = repo.repoDescription {
                                Text("Description:")
                                    .fontWeight(.bold)
                                Text(description)
                            }
                            if let owner = repo.owner {
                                Text("Author:")
                                    .fontWeight(.bold)
                                HStack {
                                    if let urlString = owner.avatarURL,
                                       let url = URL(string: urlString) {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 55, height: 55)
                                        .clipShape(Circle())
                                    }
                                    Text(owner.login)
                                }
                            }
                            Text("Stats:")
                                .fontWeight(.bold)
                            Label {
                                Text("\(repo.watchersCount ?? 0)")
                            } icon: {
                                Image(systemName: "eye")
                                    .frame(width: 24)
                            }
                            Label {
                                Text("\(repo.forksCount ?? 0)")
                            } icon: {
                                Image(systemName: "arrow.triangle.branch")
                                    .frame(width: 24)
                            }
                            Label {
                                Text("\(repo.stargazersCount ?? 0)")
                            } icon: {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .frame(width: 24)
                            }

                            if let license = repo.license {
                                Text("License:")
                                    .fontWeight(.bold)
                                Text(license.name)
                            }
                        }
                        else {
                            Text("No data. Try refreshing")
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .refreshable {
            viewModel.loadData(scrappedRepo: repo)
        }
        .onAppear {
            viewModel.loadData(scrappedRepo: repo)
        }
        .alert("Error loading project information", isPresented: $viewModel.errorAlert) {
            Button("OK", role: .cancel) { }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.shortName(scrappedRepo: repo))
    }
}

struct RepoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RepoDetailView(repo: ScrappedRepo(name: "github/mona-sans"), openURLAction: OpenURLAction(handler: { _ in .systemAction }))
    }
}
