//
//  Publisher+ApiResponse.swift
//  iGHSearch
//
//  Created by s.zhelev on 24.01.22.
//

import Foundation
import Combine

struct ApiError: Codable, CustomNSError, Identifiable {
    var id: String { UUID().uuidString }
    var message: String?
}

struct ApiResponse<T: Decodable>: Decodable {
    var total_count: Int?
    var items: [T]?
    var message: String?
}

extension Publisher where Output == URLSession.DataTaskPublisher.Output {

    func decodedApiResponse<T: Decodable>(using decoder:JSONDecoder = .init()) -> AnyPublisher<ApiResponse<T>, Error> {
        
        return self
            .map {
                 $0.data
            }
            .decodeJSON(decoder: decoder)
            .tryMap { (response: ApiResponse<T>) in

                if let error = response.message {

                    throw ApiError(message: error)
                }
                
                guard response.items != nil else {

                    throw ApiError(message: "Invalid response")
                }
                
                return response
            }
            .eraseToAnyPublisher()
    }
}
