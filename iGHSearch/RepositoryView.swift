//
//  RepositoryView.swift
//  iGHSearch
//
//  Created by s.zhelev on 24.01.22.
//

import Foundation
import SwiftUI

struct RepositoryView: View {
    private let repo: GitRepository
    init(repository: GitRepository) {
        self.repo = repository
    }
    
    var body: some View {
        HStack {
            AsyncImage(
                url: repo.owner.avatarUrl,
                placeholder: { Color(uiColor: UIColor.lightGray) },
                image: { Image(uiImage: $0).resizable() }
             ).frame(width: 80, height: 80)
            
            VStack(alignment: .leading, spacing: 15) {
                Text(repo.name)
                    .font(.system(size: 18))
                    .foregroundColor(Color.blue)
                Text(repo.description ?? "")
                    .font(.system(size: 14))
            }
        }.onTapGesture() {
            UIApplication.shared.open(repo.url)
        }
        .padding(8)
    }
}
