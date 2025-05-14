//
//  CharacterRepositoryFactoryProtocol.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 14/05/25.
//

protocol CharacterRepositoryFactoryProtocol {
    func build(tier: UserTier) -> CharacterRepositoryProtocol
}
