//
//  Episode.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 14/05/25.
//

public struct Episode {
    let id: String
    let episode: String
    let name: String
    let airDate: String
}

extension Episode: Equatable {
    public static func == (lhs: Episode, rhs: Episode) -> Bool {
        lhs.id == rhs.id
    }
}
