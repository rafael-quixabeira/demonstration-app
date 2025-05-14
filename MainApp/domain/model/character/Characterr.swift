//
//  Character.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 14/05/25.
//

import Foundation

public struct Characterr { // this is not a typo
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

extension Characterr: Equatable {
    public static func == (lhs: Characterr, rhs: Characterr) -> Bool {
        lhs.id == rhs.id
    }
}
