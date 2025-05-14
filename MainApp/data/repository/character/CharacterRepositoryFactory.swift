//
//  CharacterRepositoryFactory.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 10/05/25.
//

class CharacterRepositoryFactory {
    let bareRepository: CharacterRepositoryProtocol
    let cachedRepository: CharacterRepositoryProtocol

    init(
        bareRepository: CharacterRepositoryProtocol,
        cachedRepository: CharacterRepositoryProtocol
    ) {
        self.bareRepository = bareRepository
        self.cachedRepository = cachedRepository
    }
}

extension CharacterRepositoryFactory: CharacterRepositoryFactoryProtocol {
    func build(tier: UserTier) -> CharacterRepositoryProtocol {
        switch tier {
        case .free:
            return bareRepository
        case .premium, .vip:
            return cachedRepository
        }
    }
}
