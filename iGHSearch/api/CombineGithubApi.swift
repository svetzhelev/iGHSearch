//
//  GithubApi.swift
//  iGHSearch
//
//  Created by s.zhelev on 23.01.22.
//

import Foundation
import Combine

struct CombineGithubApi {
    
    private let networkClient: INetworkClient
    private let apiRoutes: Endpoints
    
    fileprivate struct GithubApi: Endpoints {
        var searchEndpoint: URL { URL(string: Config.BASE_URL)!.appendingPathComponent("/search/repositories")}
    }

    init(routes: Endpoints, networkClient: INetworkClient) {
        self.apiRoutes = routes
        self.networkClient = networkClient
    }
    
    func search(searchTerm: String, page: Int) -> AnyPublisher<ApiResponse<GitRepository>, Error>  {
        
        var components = URLComponents(url: apiRoutes.searchEndpoint, resolvingAgainstBaseURL: true)
        components?.percentEncodedQuery = "q=\(searchTerm)&page=\(page)&per_page=\(Config.DEFAULT_PAGE_SIZE)"
        
        var request = URLRequest(url: (components?.url)!)
        request.httpMethod = "GET"
        
        return networkClient.execute(request).decodedApiResponse()
    }
}

extension CombineGithubApi {
    
    init(networkClient: INetworkClient) {
        
        self.init(routes: GithubApi(), networkClient: networkClient)
    }
}
