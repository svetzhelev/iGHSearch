//
//  GithubRepository.swift
//  iGHSearch
//
//  Created by s.zhelev on 23.01.22.
//

import Foundation
import Combine

protocol GithubRepositoryState {
    var query: String? { get set }
    var page: Int { get set }
    var totalResults: Int { get set }
}

struct InMemoryState : GithubRepositoryState {
    var query: String? = nil
    var page: Int = 0
    var totalResults: Int = 0
}

class GithubRepository {
    
    private(set) var state: GithubRepositoryState
    private let ghApi: CombineGithubApi
    
    init(githubApi: CombineGithubApi, state: GithubRepositoryState = InMemoryState()) {
        self.ghApi = githubApi
        self.state = state
    }
    
    func reset() {
        
        state.page = 0
        state.query = nil
        state.totalResults = 0
    }
    
    func searcRepositories(query: String) -> AnyPublisher<[GitRepository], Error> {
        
        state.page += 1
        
        return ghApi.search(searchTerm: query, page: state.page)
            .handleEvents(receiveOutput: { [weak self] response in
                self?.state.query = query
                self?.state.totalResults = response.total_count ?? Config.DEFAULT_PAGE_SIZE
            })
            .tryMap { (response: ApiResponse<GitRepository>) in
                
                return response.items ?? []
            }
            .eraseToAnyPublisher()
    }
}
