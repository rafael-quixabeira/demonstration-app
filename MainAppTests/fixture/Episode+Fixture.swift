//
//  Episode+Fixture.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 14/05/25.
//

import Foundation
@testable import MainApp

extension Episode {
    static func fixture(id: String, episode: String) -> Episode {
        .init(id: id, episode: episode, name: "name", airDate: "December 2, 2013")
    }
}
