//
//  CharacterListViewModelTests.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 14/05/25.
//

import XCTest
import Combine
import Foundation
import Infrastructure
@testable import MainApp

final class CharacterListViewModelTests: XCTestCase {
    private var viewModel: CharacterListView.ViewModel!
    private var useCase: MockCharacterUseCase!
    private var logger: LoggerProtocol!
    private var cancellables: Set<AnyCancellable>!

    let characters: [Characterr] = [
        .fixture(id: "1", name: "Rick"),
        .fixture(id: "2", name: "Morty"),
    ]

    override func setUp() {
        super.setUp()

        useCase = MockCharacterUseCase()
        logger = DummyLogger()
        cancellables = []

        viewModel = CharacterListView.ViewModel(characterUseCase: useCase, logger: logger)
    }

    override func tearDown() {
        viewModel = nil
        useCase = nil
        logger = nil
        cancellables = nil
        super.tearDown()
    }

    func test_fetch_whenSuccessful_shouldUpdateStateToLoadingThenLoaded() async {
        useCase.stubbedResult = .success(characters, pages: 2)
        var states: [ViewState<[Characterr]>] = []

        viewModel.$list
            .sink { state in
                states.append(state)
            }
            .store(in: &cancellables)

        await viewModel.fetch()

        await XCTAssertAsync {
            states.count == 3 &&
            states[0].isUndefinedState &&
            states[1].isInLoadingState &&
            states[2].loadedValue != nil
        }

        await XCTAssertAsync {
            self.viewModel.list.loadedValue == self.characters
        }
    }
    
    func test_fetch_whenSuccessfulWithEmptyResult_shouldUpdateStateToEmpty() async {
        useCase.stubbedResult = .success([], pages: 0)
        var states: [ViewState<[Characterr]>] = []

        viewModel.$list
            .dropFirst()
            .sink { state in
                states.append(state)
            }
            .store(in: &cancellables)

        await viewModel.fetch()

        await XCTAssertAsync {
            states.count == 2 &&
            states[0].isInLoadingState &&
            states[1].isEmptyState
        }
    }
    
    func test_fetch_whenFails_shouldUpdateStateToLoadingThenError() async {
        useCase.stubbedResult = .failure(MockError.someError)
        var states: [ViewState<[Characterr]>] = []

        viewModel.$list
            .sink { state in
                states.append(state)
            }
            .store(in: &cancellables)

        await viewModel.fetch()

        await XCTAssertAsync {
            states.count == 3 &&
            states[0].isUndefinedState &&
            states[1].isInLoadingState &&
            states[2].isInErrorState
        }
    }
    
    // MARK: - Prefetch Tests
    
    func test_prefetch_whenPageIsGreaterThanCurrent_shouldAppendNewPage() async {
        useCase.stubbedResult = .success([characters[0]], pages: 2)
        
        await viewModel.fetch()
        
        await XCTAssertAsync {
            self.viewModel.list.loadedValue?.count == 1
        }

        useCase.stubbedResult = .success([characters[1]], pages: 2)
        viewModel.prefetch(page: 2)

        await XCTAssertAsync(timeout: 5.0) {
            self.viewModel.list.loadedValue?.contains(self.characters[1]) ?? false
        }
    }
    
    func test_prefetch_whenPageIsLessOrEqualThanCurrent_shouldNotAppendPage() async {
        useCase.stubbedResult = .success([characters[0]], pages: 2)

        await viewModel.fetch()
        
        await XCTAssertAsync {
            self.viewModel.list.loadedValue?.count == 1
        }

        useCase.stubbedResult = .success([characters[1]], pages: 2)
        viewModel.prefetch(page: 1)

        await XCTAssertAsync(timeout: 3.0) {
            self.viewModel.list.loadedValue?.count == 1
        }
    }

    func test_searchQuery_whenChanged_shouldCallFetchWithCorrectParameters() async {
        useCase.stubbedResult = .success(characters, pages: 1)

        let expectation = XCTestExpectation(description: "Fetch should be called after debounce with correct query")

        useCase.onFetchCharacters = { query in
            let hasNameQuery = query.contains { $0.0 == "name" && $0.1 == "Rick" }
            XCTAssertTrue(hasNameQuery, "The 'name' parameter was not passed to the use case.")
            expectation.fulfill()
        }

        viewModel.searchQuery = "Rick"

        await fulfillment(of: [expectation], timeout: 2.0)
    }
}

private final class MockCharacterUseCase: CharacterUseCaseProtocol {
    var stubbedResult: Result?
    var onFetchCharacters: ((KeyValuePairs<String, String>) -> Void)?

    func fetchCharacters(query: KeyValuePairs<String, String>) async throws -> CharacterPage {
        onFetchCharacters?(query)
        switch stubbedResult {
        case .success(let characters, let pages):
            return CharacterPage(info: .init(count: 20, pages: pages), characters: characters)
        case .failure(let error):
            throw error
        case .none:
            fatalError("Stubbed result not configured")
        }
    }

    func fetchCharacter(id: String) async throws -> Characterr {
        fatalError("Method not implemented")
    }

    enum Result {
        case success([Characterr], pages: Int)
        case failure(Error)
    }
}

extension XCTestCase {
    func XCTAssertAsync(
        timeout: TimeInterval = 2.0,
        _ predicate: @escaping () -> Bool
    ) async {
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate { _, _ in
                predicate()
            },
            object: nil
        )

        await fulfillment(of: [expectation], timeout: timeout)
    }
}
