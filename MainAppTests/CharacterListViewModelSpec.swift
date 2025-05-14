import Quick
import Nimble
import Combine
import Foundation
@testable import MainApp

final class CharacterListViewModelSpec: AsyncSpec {
    override class func spec() {
        var viewModel: CharacterListView.ViewModel!
        var useCase: MockCharacterUseCase!
        var logger: LoggerProtocol!
        var cancellables: [AnyCancellable] = []
        
        beforeEach {
            useCase = MockCharacterUseCase()
            logger = DummyLogger()
            viewModel = CharacterListView.ViewModel(characterUseCase: useCase, logger: logger)
        }

        describe("fetch()") {
            context("when the fetch operation is successful") {
                it("should update the state to loading and then loaded") {
                    useCase.stubbedResult = .success([
                        CharacterListViewModelSpec.makeCharacter(id: 1),
                        CharacterListViewModelSpec.makeCharacter(id: 2)
                    ], pages: 2)

                    var states: [ViewState<[CharacterDTO]>] = []

                    viewModel.$list.sink { state in
                        states.append(state)
                    }.store(in: &cancellables)
                    
                    await viewModel.fetch()

                    expect(states.count).to(equal(3))
                    expect(states[0].isUndefinedState).to(beTrue())
                    expect(states[1].isInLoadingState).to(beTrue())
                    expect(states[2].loadedValue).toNot(beNil())

                    await expect(viewModel.list.loadedValue).toEventually(equal([
                        CharacterListViewModelSpec.makeCharacter(id: 1),
                        CharacterListViewModelSpec.makeCharacter(id: 2)
                    ]), timeout: .seconds(2))
                }
            }

            context("when the fetch operation fails") {
                it("should update the state to loading and then error") {
                    useCase.stubbedResult = .failure(MockError.someError)

                    var states: [ViewState<[CharacterDTO]>] = []

                    viewModel.$list.sink { state in
                        states.append(state)
                    }.store(in: &cancellables)

                    await viewModel.fetch()

                    expect(states.count).to(equal(3))
                    expect(states[0].isUndefinedState).to(beTrue())
                    expect(states[1].isInLoadingState).to(beTrue())
                    expect(states[2].isInErrorState).to(beTrue())
                }
            }
        }

        describe("prefetch(page:)") {
            it("deve acionar append(page:) quando chamado com página maior que a atual") {
                useCase.stubbedResult = .success([
                    CharacterListViewModelSpec.makeCharacter(id: 1)
                ], pages: 2)
                
                await viewModel.fetch()

                expect(viewModel.list.loadedValue?.count) == 1

                useCase.stubbedResult = .success([
                    CharacterListViewModelSpec.makeCharacter(id: 2)
                ], pages: 2)

                viewModel.prefetch(page: 2)
                // throttle: aguarda um pouco
                try? await Task.sleep(for: .seconds(3))

                await expect(viewModel.list.loadedValue)
                    .toEventually(contain(CharacterListViewModelSpec.makeCharacter(id: 2)), timeout: .seconds(2))
            }

            it("não deve acionar append(page:) se a página for menor ou igual à atual") {
                useCase.stubbedResult = .success([
                    CharacterListViewModelSpec.makeCharacter(id: 1)
                ], pages: 2)

                await viewModel.fetch()

                expect(viewModel.list.loadedValue?.count) == 1

                useCase.stubbedResult = .success([
                    CharacterListViewModelSpec.makeCharacter(id: 2)
                ], pages: 2)

                viewModel.prefetch(page: 1)

                try? await Task.sleep(nanoseconds: 300_000_000)

                expect(viewModel.list.loadedValue?.count) == 1
            }
        }
    }
}

// MARK: - Helpers e Mocks

private extension CharacterListViewModelSpec {
    static func makeCharacter(id: Int) -> CharacterDTO {
        CharacterDTO(
            id: id,
            name: "Rick",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: nil,
            location: nil,
            image: URL(string: "https://example.com/image.png")!,
            episode: [],
            url: URL(string: "https://example.com/char/")!.appendingPathComponent("\(id)")
        )
    }
}

private final class MockCharacterUseCase: CharacterUseCaseProtocol {
    enum Result {
        case success([CharacterDTO], pages: Int)
        case failure(Error)
    }
    var stubbedResult: Result?
    func fetchCharacters(query: KeyValuePairs<String, String>) async throws -> WrapperCharacterDTO {
        switch stubbedResult {
        case .success(let characters, let pages):
            return WrapperCharacterDTO(info: .init(count: characters.count, pages: pages), results: characters)
        case .failure(let error):
            throw error
        case .none:
            fatalError("stubbedResult não configurado")
        }
    }
    func fetchCharacter(id: String) async throws -> CharacterDTO {
        fatalError()
    }
}

private final class DummyLogger: LoggerProtocol {
    func debug(_ message: String, category: LoggerCategory, file: String, function: String, line: Int) {}
    func info(_ message: String, category: LoggerCategory, file: String, function: String, line: Int) {}
    func notice(_ message: String, category: LoggerCategory, file: String, function: String, line: Int) {}
    func warning(_ message: String, category: LoggerCategory, file: String, function: String, line: Int) {}
    func error(_ message: String, category: LoggerCategory, file: String, function: String, line: Int) {}
}

private enum MockError: Error { case someError } 
