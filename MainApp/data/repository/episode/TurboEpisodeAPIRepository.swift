//
//  TurboEpisodeAPIRepository.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 14/05/25.
//

public class TurboEpisodeAPIRepository: EpisodeRepositoryProtocol {
    private let repository: EpisodeRepositoryProtocol

    init(repository: EpisodeRepositoryProtocol) {
        self.repository = repository
    }

    func fetchEpisodeData(id: String) async throws -> Episode {
        return try await self.repository.fetchEpisodeData(id: id)
    }

    func fetchEpisodes(ids: [String]) async throws -> [Episode] {
        try await withThrowingTaskGroup(of: Episode.self) { group in
            for id in ids {
                group.addTask {
                    try await self.fetchEpisodeData(id: id)
                }
            }

            var results: [Episode] = []

            for try await dto in group {
                results.append(dto)
            }

            return results
        }
    }
}
