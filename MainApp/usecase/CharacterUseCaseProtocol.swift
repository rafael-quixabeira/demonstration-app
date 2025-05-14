//
//  CharacterUseCaseProtocol.swift
//  akkodrickandmortyappisprueba
//
//  Created by Rafael Quixabeira on 10/05/25.
//

import Combine

protocol CharacterUseCaseProtocol {
    func fetchCharacters(query: KeyValuePairs<String, String>) async throws -> CharacterPage
    func fetchCharacter(id: String) async throws -> Character
}

class CharacterUserTierAwareUseCase {
    private let userStream: UserStreamProtocol
    private let repositoryFactory: CharacterRepositoryFactoryProtocol
    private var characterRepository: CharacterRepositoryProtocol?

    private var cancellables: [AnyCancellable] = []

    init(userStream: UserStreamProtocol, repositoryFactory: CharacterRepositoryFactoryProtocol) {
        self.userStream = userStream
        self.repositoryFactory = repositoryFactory
        self.observerUserStream()
    }

    private func observerUserStream() {
        userStream.user.compactMap { $0 }.sink { [weak self] user in
            guard let self else { return }
            self.characterRepository = self.repositoryFactory.build(tier: user.tier)
        }.store(in: &cancellables)
    }
}

extension CharacterUserTierAwareUseCase: CharacterUseCaseProtocol {
    func fetchCharacters(query: KeyValuePairs<String, String>) async throws -> CharacterPage {
        guard let repository = self.characterRepository else {
            fatalError("repository not available, at this method it should not happen")
        }

        return try await repository.fetchCharacters(query: query)
    }

    func fetchCharacter(id: String) async throws -> Character {
        guard let repository = self.characterRepository else {
            fatalError("repository not available, at this method it should not happen")
        }

        return try await repository.fetchCharacter(id: id)
    }
}
