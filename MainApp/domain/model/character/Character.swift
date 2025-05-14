//
//  Character.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 14/05/25.
//

import Foundation

public struct Character {
    let id: String
    let name: String
    let origin: String?
    let status: CharacterStatus
    let species: String
    let image: URL
    let episodes: [URL]
}

enum CharacterStatus: String {
    case alive
    case dead
    case unknown
}

extension Character: Equatable {
    public static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id
    }
}
