//
//  Publisher+decodeJSON.swift
//  iGHSearch
//
//  Created by s.zhelev on 23.01.22.
//

import Foundation
import Combine

extension Publisher where Output: Decodable {
    
    public func decodeJSON<Item>(decoder: JSONDecoder = .init()) -> Publishers.Decode<Self, Item, JSONDecoder> where Item : Decodable, Self.Output == JSONDecoder.Input {
        
        decode(type: Item.self, decoder: decoder)
    }
}
