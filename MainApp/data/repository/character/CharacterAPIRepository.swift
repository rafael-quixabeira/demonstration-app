//
//  CharacterAPIRepository.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 09/05/25.
//

import Network

class CharacterAPIRepository: CharacterRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchCharacters(query: KeyValuePairs<String, String>) async throws -> CharacterPage {
        let wrapper: WrapperCharacterDTO =  try await apiClient.perform(api: .list(query: query))
        return CharacterMapper.page(from: wrapper)
    }

    func fetchCharacter(id: String) async throws -> Characterr {
        let dto: CharacterDTO = try await apiClient.perform(api: .detail(id: id))
        return CharacterMapper.toDomain(dto)
    }
}
