//
//  EpisodeAPIRepository.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 14/05/25.
//

import Foundation
import Network

public class EpisodeAPIRepository: EpisodeRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchEpisodeData(id: String) async throws -> Episode {
        let dto: EpisodeDTO = try await self.apiClient.perform(api: .episode(id: id))
        return dto.toDomain()
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
