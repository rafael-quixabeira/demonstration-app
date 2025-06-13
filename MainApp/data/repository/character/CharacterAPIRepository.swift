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
        do {
            let wrapper: WrapperCharacterDTO =  try await apiClient.perform(api: .list(query: query))
            return CharacterMapper.page(from: wrapper)
        } catch let APIError.unexpectedStatusCode(statusCode, _) where statusCode == 404 {
            return CharacterPage(info: .init(count: 0, pages: 0), characters: [])
        } catch {
            throw error
        }
    }

    func fetchCharacter(id: String) async throws -> Characterr {
        let dto: CharacterDTO = try await apiClient.perform(api: .detail(id: id))
        return CharacterMapper.toDomain(dto)
    }
}
