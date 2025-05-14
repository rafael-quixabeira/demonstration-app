//
//  CachedEpisodeAPIRepository.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 14/05/25.
//

public class CachedEpisodeAPIRepository: EpisodeRepositoryProtocol {
    private let repository: EpisodeRepositoryProtocol
    private let cache: CacheProtocol

    init(repository: EpisodeRepositoryProtocol, cache: CacheProtocol) {
        self.repository = repository
        self.cache = cache
    }

    func fetchEpisodeData(id: String) async throws -> Episode {
        try await cache.getOrFetch(.episode(id)) {
            try await self.repository.fetchEpisodeData(id: id)
        }
    }

    func fetchEpisodes(ids: [String]) async throws -> [Episode] {
        var episodes: [Episode] = []

        for id in ids {
            let episode = try await fetchEpisodeData(id: id)
            episodes.append(episode)
        }

        return episodes
    }
}
