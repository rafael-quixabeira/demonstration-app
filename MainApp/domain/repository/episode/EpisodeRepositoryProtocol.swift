//
//  EpisodeRepositoryProtocol.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 12/05/25.
//

protocol EpisodeRepositoryProtocol {
    func fetchEpisodeData(id: String) async throws -> Episode
    func fetchEpisodes(ids: [String]) async throws -> [Episode]
}
