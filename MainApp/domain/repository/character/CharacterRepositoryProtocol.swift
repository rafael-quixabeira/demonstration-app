//
//  CharacterRepositoryProtocol.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 14/05/25.
//

protocol CharacterRepositoryProtocol {
    func fetchCharacters(query: KeyValuePairs<String, String>) async throws -> CharacterPage
    func fetchCharacter(id: String) async throws -> Characterr
}

extension CharacterRepositoryProtocol {
    func fetchCharacters() async throws -> CharacterPage {
        try await fetchCharacters(query: [:])
    }
}
