//
//  CharacterDetailViewModelSpec.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 14/05/25.
//

import Foundation
import Quick
import Nimble
import Combine
@testable import MainApp

class CharacterDetailViewModelSpec: AsyncSpec {
    override class func spec() {
        var viewModel: CharacterDetailView.ViewModel!
        var characterUseCase: CharacterUseCaseProtocolMock!
        var episodeUseCase: EpisodeUseCaseProtocolMock!
        var logger: LoggerProtocol!
        var cancellables: Set<AnyCancellable>!

        let characterID = "1"

        let character = Characterr.fixture(
            id: characterID,
            name: "Rick",
            status: .dead
        )

        let episodes: [Episode] = [
            .fixture(id: "1", episode: "1 Pilot"),
            .fixture(id: "2", episode: "2 Pilot"),
        ]

        beforeEach {
            characterUseCase = CharacterUseCaseProtocolMock()
            episodeUseCase = EpisodeUseCaseProtocolMock()
            logger = DummyLogger()
            cancellables = []
            
            viewModel = .init(
                characterID: characterID,
                characterUseCase: characterUseCase,
                episodeUseCase: episodeUseCase,
                logger: logger
            )
        }
        
        afterEach {
            cancellables = nil
        }
        
        describe("fetchCharacterData") {
            context("when the fetch is successful") {
                beforeEach {
                    characterUseCase.fetchCharacterHandler = { id in
                        return character
                    }
                }
                
                it("should update state from undefined to loading to loaded") { @MainActor in
                    var states: [ViewState<CharacterDetailView.CharacterViewData>] = []

                    viewModel.$character
                        .sink { state in
                            states.append(state)
                        }
                        .store(in: &cancellables)

                    await viewModel.fetchCharacterData()

                    await expect(states.count).toEventually(equal(3))
                    expect(states[0].isUndefinedState).to(beTrue())
                    expect(states[1].isInLoadingState).to(beTrue())
                    expect(states[2].loadedValue).toNot(beNil())
                    expect(states[2].loadedValue?.name).to(equal("Rick"))
                    expect(states[2].loadedValue?.statusEmoji).to(equal("💀"))
                    expect(characterUseCase.fetchCharacterCallCount).to(equal(1))
                    expect(characterUseCase.fetchCharacterArgValues).to(equal([characterID]))
                }
            }
            
            context("when the fetch fails") {
                beforeEach {
                    characterUseCase.fetchCharacterHandler = { _ in
                        throw MockError.someError
                    }
                }
                
                it("should update state from undefined to loading to error") { @MainActor in
                    var states: [ViewState<CharacterDetailView.CharacterViewData>] = []
                    
                    viewModel.$character
                        .sink { state in
                            states.append(state)
                        }
                        .store(in: &cancellables)

                    await viewModel.fetchCharacterData()

                    await expect(states.count).toEventually(equal(3))
                    expect(states[0].isUndefinedState).to(beTrue())
                    expect(states[1].isInLoadingState).to(beTrue())
                    expect(states[2].isInErrorState).to(beTrue())
                    expect(characterUseCase.fetchCharacterCallCount).to(equal(1))
                }
            }
        }
        
        describe("fetchEpisodeList") {
            context("when character is loaded and fetch is successful") {
                beforeEach {
                    characterUseCase.fetchCharacterHandler = { _ in
                        return character
                    }
                    episodeUseCase.fetchEpisodesHandler = { _ in
                        return episodes
                    }
                }
                
                it("should update episodes state from loading to loaded") { @MainActor in
                    var states: [ViewState<[CharacterDetailView.EpisodeViewData]>] = []
                    
                    viewModel.$episodes
                        .sink { state in
                            states.append(state)
                        }
                        .store(in: &cancellables)
                    
                    await viewModel.fetchCharacterData()
                    await viewModel.fetchEpisodeList()
                    
                    await expect(states.count).toEventually(equal(3))
                    expect(states[0].isInLoadingState).to(beTrue())
                    expect(states[1].isInLoadingState).to(beTrue())

                    expect(states[2].loadedValue).toNot(beNil())
                    expect(states[2].loadedValue?.count).to(equal(2))
                    expect(states[2].loadedValue?.first?.episode).to(equal("1 Pilot"))
                    expect(episodeUseCase.fetchEpisodesCallCount).to(equal(1))
                }
            }
            
            context("when fetch fails") {
                beforeEach {
                    characterUseCase.fetchCharacterHandler = { _ in
                        return character
                    }
                    episodeUseCase.fetchEpisodesHandler = { _ in
                        throw MockError.someError
                    }
                }
                
                it("should update episodes state to error") { @MainActor in
                    var states: [ViewState<[CharacterDetailView.EpisodeViewData]>] = []
                    
                    viewModel.$episodes
                        .sink { state in
                            states.append(state)
                        }
                        .store(in: &cancellables)

                    await viewModel.fetchCharacterData()
                    await viewModel.fetchEpisodeList()

                    await expect(states.count).toEventually(equal(3))
                    expect(states[0].isInLoadingState).to(beTrue())
                    expect(states[1].isInLoadingState).to(beTrue())
                    expect(states[2].isInErrorState).to(beTrue())
                    expect(episodeUseCase.fetchEpisodesCallCount).to(equal(1))
                }
            }
        }
    }
}
