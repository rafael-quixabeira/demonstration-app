//
//  EpisodeRepositoryFactoryProtocol.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 12/05/25.
//

protocol EpisodeRepositoryFactoryProtocol {
    func build(tier: UserTier) -> EpisodeRepositoryProtocol
}
