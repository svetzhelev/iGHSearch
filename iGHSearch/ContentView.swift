//
//  ContentView.swift
//  iGHSearch
//
//  Created by s.zhelev on 23.01.22.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var viewModel: GithubSearchViewModel
    
    @State private var queryString = ""
    @State private var subscriptions = Set<AnyCancellable>()
    @State private var error: ApiError?
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.repositories) { repo in
                        RepositoryView(repository: repo)
                        .onAppear   {
                            if viewModel.hasMoreToLoad && repo.id == viewModel.repositories.last?.id {
                                //  Last row is about to appear on screen, fetch next badge
                                doSearch()
                            }
                        }
                    }
                }
                
                VStack { EmptyView() }
                .alert(item: $error,
                       content: { error in
                        .init(title: Text("Error"),
                              message: Text(error.message ?? "Unknown error"),
                              dismissButton: .default(Text("Ok")))
                })
            }.navigationBarTitle("Github Repositories")
        }
        .searchable(text: $queryString)
        .onSubmit(of: .search) {
            viewModel.reset()
            doSearch(searchQuery: queryString)
        }
    }
    
    private func doSearch(searchQuery: String? = nil) {
        
        viewModel.search(searchTerm: searchQuery).sink { completion in
            if case .failure(let err as ApiError) = completion {
                self.error = err
            }
        } receiveValue: { _ in }
        .store(in: &subscriptions)
    }
}
