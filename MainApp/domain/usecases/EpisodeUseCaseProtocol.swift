//
//  EpisodeUseCaseProtocol.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 12/05/25.
//

import Foundation
import Combine

/// @mockable
protocol EpisodeUseCaseProtocol {
    func fetchEpisodes(urls: [URL]) async throws -> [Episode]
}

public class EpisodeUseCase {
    private var cancellables: [AnyCancellable] = []

    private let repositoryFactory: EpisodeRepositoryFactoryProtocol
    private let userStream: UserStreamProtocol
    private var repository: EpisodeRepositoryProtocol?

    init(repositoryFactory: EpisodeRepositoryFactoryProtocol, userStream: UserStreamProtocol) {
        self.repositoryFactory = repositoryFactory
        self.userStream = userStream
        observerUserStream()
    }

    private func observerUserStream() {
        userStream.user.compactMap { $0 }.sink { [weak self] user in
            guard let self else { return }
            self.repository = self.repositoryFactory.build(tier: user.tier)
        }.store(in: &cancellables)
    }
}

extension EpisodeUseCase: EpisodeUseCaseProtocol {
    func fetchEpisodes(urls: [URL]) async throws -> [Episode] {
        guard let repository = self.repository else {
            fatalError("repository not available, at this method it should not happen")
        }

        let ids = urls
            .map { $0.absoluteString }
            .compactMap { $0.split(separator: "/").last }
            .map { $0.description }

        return try await repository.fetchEpisodes(ids: ids)
    }
}
