//
//  EpisodeRepositoryFactory.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 14/05/25.
//

class EpisodeRepositoryFactory {
    let bareRepository: EpisodeRepositoryProtocol
    let cachedRepository: EpisodeRepositoryProtocol
    let turboRepository: EpisodeRepositoryProtocol

    init(
        bareRepository: EpisodeRepositoryProtocol,
        cachedRepository: EpisodeRepositoryProtocol,
        turboRepository: EpisodeRepositoryProtocol
    ) {
        self.bareRepository = bareRepository
        self.cachedRepository = cachedRepository
        self.turboRepository = turboRepository
    }
}

extension EpisodeRepositoryFactory: EpisodeRepositoryFactoryProtocol {
    func build(tier: UserTier) -> EpisodeRepositoryProtocol {
        switch tier {
        case .free:
            return bareRepository
        case .premium:
            return cachedRepository
        case .vip:
            return turboRepository
        }
    }
}
