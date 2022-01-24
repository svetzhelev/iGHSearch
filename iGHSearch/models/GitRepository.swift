//
//  GithubRepository.swift
//  iGHSearch
//
//  Created by s.zhelev on 23.01.22.
//

import Foundation

struct GitRepository: Codable, Hashable, Identifiable {
    let id: Int
    let name: String
    let owner: Owner
    let url: URL
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case owner
        case description
        case url = "html_url"
    }
}

struct Owner: Codable, Hashable {
    
    let login: String
    let avatarUrl: URL
    
    enum CodingKeys: String, CodingKey {
        
        case login
        case avatarUrl = "avatar_url"
    }
}
