//
//  CharacterListView.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 10/05/25.
//

import SwiftUI
import Factory
import Combine
import Infrastructure

struct CharacterListView: View {
    @StateObject
    private var viewModel: ViewModel = Container.shared.listViewModel.resolve()

    @EnvironmentObject
    private var router: RootView.Router

    var body: some View {
        VStack {
            switch viewModel.list {
            case .undefined, .loading:
                Color.clear.loadingOverlay(true)
            case .loaded(let data):
                CharacterTableView(
                    characters: data,
                    onPrefetch: viewModel.prefetch,
                    onTap: navigateToDetail
                )
            case .error:
                Color.clear.errorOverlay(show: true, message: Strings.genericErrorMessage) {
                    Task {
                        await viewModel.fetch()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
        .task {
            guard viewModel.list.isUndefinedState else { return }
            await viewModel.fetch()
        }
        .navigationTitle(Strings.charactersScreenTitle)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { router.presentSheet(.tierSelect) }) {
                    Image(systemName: "crown")
                        .font(.body)
                }
            }
        }
    }

    private func navigateToDetail(for character: Characterr) {
        router.push(.detail(id: character.id.description))
    }
}

extension CharacterListView {
    class ViewModel: ObservableObject {
        private let characterUseCase: CharacterUseCaseProtocol
        private let logger: LoggerProtocol
        private var cancellables: [AnyCancellable] = []

        private let prefetchStream: PassthroughSubject<Int, Never> = .init()

        private var currentPage: Int = 1
        private var maxNumberOfPages: Int?

        @Published
        var list: ViewState<[Characterr]> = .undefined

        init(characterUseCase: CharacterUseCaseProtocol, logger: LoggerProtocol) {
            self.characterUseCase = characterUseCase
            self.logger = logger

            observe()
        }

        private func observe() {
            prefetchStream.throttle(for: .seconds(0.25), scheduler: RunLoop.main, latest: false).sink { [weak self] page in
                Task {
                    await self?.append(page: page)
                }
            }.store(in: &cancellables)
        }

        private func fetch(page: Int = 1) async throws -> [Characterr] {
            let params: KeyValuePairs<String, String> = [
                "page": page.description
            ]

            let wrapper = try await self.characterUseCase.fetchCharacters(
                query: params
            )

            maxNumberOfPages = wrapper.info.pages

            return wrapper.characters
        }

        @MainActor
        public func fetch() async {
            do {
                list = .loading
                let data = try await self.fetch(page: currentPage)
                list = .loaded(data)
            } catch {
                list = .error(nil)
            }
        }

        public func prefetch(page: Int) {
            prefetchStream.send(page)
        }

        @MainActor
        private func append(page: Int) async {
            guard case .loaded(let currentCharacters) = list else { return }
            guard currentPage < page else { return }

            do {
                let newData = try await self.fetch(page: page)
                list = .loaded(currentCharacters + newData)

                currentPage = page
            } catch {
                logger.error("error while fetching next page page:\(page) error:\(error)", category: .general)
            }
        }
    }
}
