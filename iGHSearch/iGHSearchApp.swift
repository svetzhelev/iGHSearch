//
//  iGHSearchApp.swift
//  iGHSearch
//
//  Created by s.zhelev on 23.01.22.
//

import SwiftUI

@main
struct iGHSearchApp: App {
    
    private let githubSearchViewModel = GithubSearchViewModel(repository: GithubRepository(githubApi: CombineGithubApi(networkClient: CombineUrlSessionClient())))
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: githubSearchViewModel)
        }
    }
}
