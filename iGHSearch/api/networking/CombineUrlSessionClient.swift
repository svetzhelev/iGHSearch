//
//  CombineUrlSessionClient.swift
//  iGHSearch
//
//  Created by s.zhelev on 23.01.22.
//

import Foundation
import Combine

class CombineUrlSessionClient: INetworkClient {
    
    private let session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        
        configuration.httpAdditionalHeaders = [
            "Accept": "application/json",
            "Authorization": "token \(Config.TOKEN)"
        ]
        
        session = URLSession(configuration: configuration)
    }
    
    func execute(_ request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), Error> {
        var requestWithCachePolicy = request
        requestWithCachePolicy.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        return self
            .session.dataTaskPublisher(for: request)
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
