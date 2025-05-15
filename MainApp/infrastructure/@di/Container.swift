//
//  Container.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 10/05/25.
//

import Foundation
import Factory
import Network

extension Container {
    var environment: Factory<Environment> {
        self {
            DummyHardcodedEnvs()
//            ArkanaEnvs()
//            XCodeConfigEnvs()
        }.cached
    }
    
    var logger: Factory<LoggerProtocol> {
        self { OSLogger() }
    }

    var inMemoryCache: Factory<CacheProtocol> {
        self {
            InMemoryCache(logger: self.logger.resolve())
        }.singleton
    }

    var lifecycleAwareCache: Factory<CacheProtocol> {
        self {
            ApplicatonLifecycleAwareCache(
                logger: self.logger.resolve(),
                lifecycleEvents: self.lifecycleEvents.resolve()
            )
        }.singleton
    }

    var lifecycleEvents: Factory<LifecycleEventsProtocol> {
        self {
            IOSLifecycleEvents(logger: self.logger.resolve())
        }.cached
    }
}

extension Container {
    var apiClient: Factory<APIClientProtocol> {
        self {
            HTTPAPIClient(
                baseURL: self.environment.resolve().apiURL,
                logger: self.logger.resolve()
            )
        }
    }
}

extension Container {
    var characterRepository: Factory<CharacterRepositoryProtocol> {
        self {
            CharacterAPIRepository(apiClient: self.apiClient.resolve())
        }
    }

    var characterCachedRepository: Factory<CharacterRepositoryProtocol> {
        self {
            CachedCharacterAPIRepository(
                apiRepository: self.characterRepository.resolve(),
                cache: self.lifecycleAwareCache.resolve()
            )
        }
    }

    var characterRepositoryFactory: Factory<CharacterRepositoryFactoryProtocol> {
        self {
            CharacterRepositoryFactory(
                bareRepository: self.characterRepository.resolve(),
                cachedRepository: self.characterCachedRepository.resolve()
            )
        }
    }
}

extension Container {
    var episodeRepository: Factory<EpisodeRepositoryProtocol> {
        self {
            EpisodeAPIRepository(apiClient: self.apiClient.resolve())
        }
    }

    var cachedEpisodeRepository: Factory<EpisodeRepositoryProtocol> {
        self {
            CachedEpisodeAPIRepository(
                repository: self.episodeRepository.resolve(),
                cache: self.lifecycleAwareCache.resolve()
            )
        }
    }

    var turboEpisodeRepository: Factory<EpisodeRepositoryProtocol> {
        self {
            TurboEpisodeAPIRepository(
                repository: self.cachedEpisodeRepository.resolve()
            )
        }
    }

    var episodeRepositoryFactory: Factory<EpisodeRepositoryFactoryProtocol> {
        self {
            EpisodeRepositoryFactory(
                bareRepository: self.episodeRepository.resolve(),
                cachedRepository: self.cachedEpisodeRepository.resolve(),
                turboRepository: self.turboEpisodeRepository.resolve()
            )
        }
    }
}

extension Container {
    private var userCombineState: Factory<UserCombineStream> {
        self { UserCombineStream() }.cached
    }

    var userStream: Factory<UserStreamProtocol> {
        self {
            self.userCombineState.resolve() as UserStreamProtocol
        }
    }

    var userMutable: Factory<MutableUserStreamProtocol> {
        self {
            self.userCombineState.resolve() as MutableUserStreamProtocol
        }
    }
}

extension Container {
    var characterUseCase: Factory<CharacterUseCaseProtocol> {
        self {
            CharacterUserTierAwareUseCase(
                userStream: self.userStream.resolve(),
                repositoryFactory: self.characterRepositoryFactory.resolve()
            )
        }
    }
 
    var episodeUseCase: Factory<EpisodeUseCaseProtocol> {
        self {
            EpisodeUseCase(
                repositoryFactory: self.episodeRepositoryFactory.resolve(),
                userStream: self.userStream.resolve()
            )
        }
    }
}

extension Container {
    var homeViewModel: Factory<HomeView.ViewModel> {
        self {
            HomeView.ViewModel(
                userStream: self.userMutable.resolve(),
                environment: self.environment.resolve()
            )
        }
    }

    var listViewModel: Factory<CharacterListView.ViewModel> {
        self {
            CharacterListView.ViewModel(
                characterUseCase: self.characterUseCase.resolve(),
                logger: self.logger.resolve()
            )
        }
    }

    var detailViewModel: ParameterFactory<String, CharacterDetailView.ViewModel> {
        ParameterFactory(self) { id in
            CharacterDetailView.ViewModel(
                characterID: id,
                characterUseCase: self.characterUseCase.resolve(),
                episodeUseCase: self.episodeUseCase.resolve(),
                logger: self.logger.resolve()
            )
        }
    }

    var tierSelectionViewModel: Factory<TierSelectionSheet.ViewModel> {
        self {
            TierSelectionSheet.ViewModel(
                userStream: self.userMutable.resolve()
            )
        }
    }
}
