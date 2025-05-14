//
//  CharacterCacheableAPIRepository.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 09/05/25.
//

class CachedCharacterAPIRepository: CharacterRepositoryProtocol {
    private let apiRepository: CharacterRepositoryProtocol
    private let cache: CacheProtocol

    init(apiRepository: CharacterRepositoryProtocol, cache: CacheProtocol) {
        self.apiRepository = apiRepository
        self.cache = cache
    }

    func fetchCharacters(query: KeyValuePairs<String, String>) async throws -> CharacterPage {
        let data: CharacterPage = try await cache.getOrFetch(.characters(query.description), fetch: { [unowned self] in
            try await self.apiRepository.fetchCharacters()
        })

        for character in data.characters {
            await cache.set(.character(character.id.description), character)
        }

        return data
    }

    func fetchCharacter(id: String) async throws -> Character {
        let data: Character = try await cache.getOrFetch(.character(id), fetch: { [unowned self] in
            try await self.apiRepository.fetchCharacter(id: id)
        })

        return data
    }
}
