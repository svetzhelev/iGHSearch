//
//  GitRepositoriesList.swift
//  iGHSearch
//
//  Created by s.zhelev on 24.01.22.
//

import Foundation

struct GitRepositoriesList: Decodable, Hashable {
    let items: [GitRepository]?
    let total_count: Int
    
//    enum DecodingKeys: String, CodingKey {
//
//        case items
//        case totalCount = "total_count"
//    }
}
