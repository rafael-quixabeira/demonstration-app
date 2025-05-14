//
//  Character+Fixture.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 14/05/25.
//

import Foundation
@testable import MainApp

extension Characterr {
    static func fixture(id: String, name: String, status: CharacterStatus = .alive) -> Characterr {
        .init(
            id: id,
            name: name,
            origin: nil,
            status: status,
            species: "Human",
            image: URL(string: "https://example.com/image.png")!,
            episodes: [
                URL(string: "https://example.com/episode/1")!,
                URL(string: "https://example.com/episode/2")!,
            ],
        )
    }
}
