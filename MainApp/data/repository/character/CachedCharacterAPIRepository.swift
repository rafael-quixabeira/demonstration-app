//
//  CharacterCacheableAPIRepository.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 09/05/25.
//

import Infrastructure

class CachedCharacterAPIRepository: CharacterRepositoryProtocol {
    private let apiRepository: CharacterRepositoryProtocol
    private let cache: CacheProtocol

    init(apiRepository: CharacterRepositoryProtocol, cache: CacheProtocol) {
        self.apiRepository = apiRepository
        self.cache = cache
    }

    func fetchCharacters(query: KeyValuePairs<String, String>) async throws -> CharacterPage {
        let data: CharacterPage = try await cache.getOrFetch(.characters(query.description), fetch: { [unowned self] in
            try await self.apiRepository.fetchCharacters(query: query)
        })

        for character in data.characters {
            await cache.set(.character(character.id.description), character)
        }

        return data
    }

    func fetchCharacter(id: String) async throws -> Characterr {
        let data: Characterr = try await cache.getOrFetch(.character(id), fetch: { [unowned self] in
            try await self.apiRepository.fetchCharacter(id: id)
        })

        return data
    }
}
