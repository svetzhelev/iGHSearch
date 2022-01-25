//
//  CombineGithubApiMocked.swift
//  iGHSearchTests
//
//  Created by s.zhelev on 25.01.22.
//

import Foundation
import Combine
@testable import iGHSearch

extension CombineGithubApi {
    
    private class MockedEndpoints: Endpoints {
        
        lazy var base: URL = Bundle(url: Bundle(for: type(of: self)).url(forResource: "Mocks", withExtension: "bundle")!)!.bundleURL
        lazy var searchEndpoint: URL = base.appendingPathComponent("search/repositories")
    }
    
    private class MockedNetworkClient: INetworkClient {
        
        func execute(_ request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), Error> {
            
            let data = try! Data(contentsOf: request.url!)
            let response: URLResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return Just((data, response)).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
    
    static var mocked: Self {
        .init(routes: MockedEndpoints(), networkClient: MockedNetworkClient())
    }
}
