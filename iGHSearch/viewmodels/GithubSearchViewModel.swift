//
//  GithubSearchViewModel.swift
//  iGHSearch
//
//  Created by s.zhelev on 23.01.22.
//

import Foundation
import Combine

class GithubSearchViewModel: ObservableObject {
    
    @Published var repositories: [GitRepository] = []
    
    private let githubRepository: GithubRepository
    
    var hasMoreToLoad: Bool {
        get {
            ceil(Double(githubRepository.state.totalResults) / Double(Config.DEFAULT_PAGE_SIZE)) > Double(githubRepository.state.page)
        }
    }
    
    init(repository: GithubRepository) {
        self.githubRepository = repository
    }
    
    func reset() {
        repositories = []
        self.githubRepository.reset()
    }
    
    func search(searchTerm: String? = nil) -> AnyPublisher<[GitRepository], Error>  {
        
        let query = searchTerm ?? githubRepository.state.query
        
        return githubRepository.searcRepositories(query: query!)
                            .receive(on: DispatchQueue.main)
                            .handleEvents(receiveOutput: { [weak self] repositories in
                                self?.repositories.append(contentsOf: repositories)
                            })
                            .eraseToAnyPublisher()
    }
}
