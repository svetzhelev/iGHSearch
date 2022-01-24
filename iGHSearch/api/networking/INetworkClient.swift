//
//  INetworkClient.swift
//  iGHSearch
//
//  Created by s.zhelev on 23.01.22.
//

import Foundation
import Combine

//  Protocol for the underlying network client that performs the API requests.
protocol INetworkClient {
    
    func execute(_ request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), Error>
}
