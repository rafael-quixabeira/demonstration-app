//
//  CharacterDetailView.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 11/05/25.
//

import SwiftUI
import Factory
import Kingfisher

struct CharacterDetailView: View {
    @StateObject
    private var viewModel: ViewModel

    @EnvironmentObject
    private var router: RootView.Router

    init(characterID: String) {
        _viewModel = StateObject(wrappedValue: Container.shared.detailViewModel.resolve(characterID))
    }

    @ViewBuilder
    func buildPair(title: String, value: String) -> some View {
        Text("\(title): ")
            .font(.subheadline)
            .fontWeight(.bold) +
        Text(value)
            .font(.subheadline)
            .fontWeight(.regular)
    }

    var body: some View {
        VStack(spacing: 24.0) {
            if case .loaded(let data) = viewModel.character {
                CardView {
                    HStack {
                        KFImage(data.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 8.0, style: .continuous))

                        VStack(alignment: .leading) {
                            Text(data.name)
                                .font(.headline)

                            HStack {
                                buildPair(title: Strings.statusLabel, value: data.status)
                                Text(data.statusEmoji)
                            }
                            
                            buildPair(title: Strings.originLabel, value: data.origin)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .task {
                        await viewModel.fetchEpisodeList()
                    }
                }.padding(.horizontal, 24.0)
            }

            Text(Strings.lastEpisodesTitle)
                .font(.largeTitle)
                .fontWeight(.heavy)

            VStack {
                if case .loaded(let data) = viewModel.episodes {
                    List(data) { episode in
                        VStack(alignment: .leading) {
                            buildPair(title: episode.episode, value: episode.name)
                            buildPair(title: Strings.airDateLabel, value: episode.airDate)
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        .padding(.horizontal, 24.0)
                        .padding(.vertical, 8.0)
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                    .refreshable(action: {
                        Task {
                            await viewModel.fetchEpisodeList()
                        }
                    })
                } else {
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            .loadingOverlay(viewModel.episodes.isInLoadingState)
            .errorOverlay(show: viewModel.episodes.isInErrorState, message: Strings.genericErrorMessage) {
                Task {
                    await viewModel.fetchEpisodeList()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 16.0)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
        .loadingOverlay(viewModel.character.isInLoadingState)
        .errorOverlay(show: viewModel.character.isInErrorState, message: Strings.genericErrorMessage) {
            Task {
                await viewModel.fetchCharacterData()
            }
        }
        .navigationTitle(viewModel.character.loadedValue?.name ?? Strings.characterScreenTitle)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { router.presentSheet(.tierSelect) }) {
                    Image(systemName: "crown")
                        .font(.body)
                }
            }
        }
        .task {
            guard viewModel.character.isUndefinedState else { return }
            await viewModel.fetchCharacterData()
        }
    }
}

extension CharacterDetailView {
    class ViewModel: ObservableObject {
        private let characterID: String
        private let characterUseCase: CharacterUseCaseProtocol
        private let episodeUseCase: EpisodeUseCaseProtocol
        private let logger: LoggerProtocol

        @Published
        public var character: ViewState<CharacterViewData> = .undefined

        @Published
        public var episodes: ViewState<[EpisodeViewData]> = .loading

        init (
            characterID: String,
            characterUseCase: CharacterUseCaseProtocol,
            episodeUseCase: EpisodeUseCaseProtocol,
            logger: LoggerProtocol
        ) {
            self.characterID = characterID
            self.characterUseCase = characterUseCase
            self.episodeUseCase = episodeUseCase
            self.logger = logger
        }

        @MainActor
        public func fetchCharacterData() async {
            do {
                character = .loading
                let data = try await characterUseCase.fetchCharacter(id: characterID)
                character = .loaded(.toViewData(from: data))
            } catch {
                logger.error("an error occurred while fetching character", category: .general)
                character = .error(nil)
            }
        }

        @MainActor
        public func fetchEpisodeList() async {
            guard case .loaded(let character) = character else {
                return
            }

            let lastTenEpisodes = Array(character.episodes.suffix(20))

            do {
                episodes = .loading
                let data = try await episodeUseCase.fetchEpisodes(urls: lastTenEpisodes)
                episodes = .loaded(data.map(EpisodeViewData.toViewData))
            } catch {
                logger.error("an error occurred while fetching character. error:\(error)", category: .general)
                episodes = .error(nil)
            }
        }
    }
}

extension CharacterDetailView {
    struct CharacterViewData: Identifiable, Equatable {
        let id: String
        let name: String
        let status: String
        let statusEmoji: String
        let origin: String
        let image: URL
        let episodes: [URL]

        static func toViewData(from character: Characterr) -> Self {
            .init(
                id: character.id,
                name: character.name,
                status: character.status.rawValue.capitalized,
                statusEmoji: character.status.emoji,
                origin: character.origin ?? Strings.unknownLabel,
                image: character.image,
                episodes: character.episodes
            )
        }
    }

    struct EpisodeViewData: Identifiable, Equatable {
        let id: String
        let episode: String
        let name: String
        let airDate: String

        static func toViewData(from episode: Episode) -> Self {
            .init(
                id: episode.id,
                episode: episode.episode,
                name: episode.name,
                airDate: episode.airDate
            )
        }
    }
}

private extension CharacterStatus {
    var emoji: String {
        switch self {
        case .alive:
            return "🤩"
        case .dead:
            return "💀"
        case .unknown:
            return "❓"
        }
    }
}
