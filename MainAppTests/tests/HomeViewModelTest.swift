//
//  HomeViewModelTest.swift
//  MainAppTests
//
//  Created by Rafael Quixabeira on 14/05/25.
//

import Testing
import Combine
@testable import MainApp

struct HomeViewModelTest {
    private var cancellables: Set<AnyCancellable> = []

    @Test("Initial state should have default values")
    func initialState() {
        let userStream = MutableUserStreamProtocolMock()
        let viewModel = HomeView.ViewModel(userStream: userStream)

        #expect(viewModel.username.isEmpty)
        #expect(viewModel.selectedTier == .free)
        #expect(viewModel.validation == nil)
        #expect(viewModel.options == UserTier.allCases)
    }

    @Test("Empty username should show validation error")
    func emptyUsernameValidation() {
        let userStream = MutableUserStreamProtocolMock()
        let viewModel = HomeView.ViewModel(userStream: userStream)

        viewModel.setUserData()

        #expect(viewModel.validation == Strings.usernameRequiredMessage)
        #expect(userStream.updateUserCallCount == 0)
    }
    
    @Test("Valid user data should update stream and navigate to list")
    mutating func validUserDataUpdate() async throws {
        let userStream = MutableUserStreamProtocolMock()
        let viewModel = HomeView.ViewModel(userStream: userStream)
        var navigationEvents: [RootView.Screen] = []

        // Setup navigation observation
        viewModel.navigationStream.sink { screen in
            navigationEvents.append(screen)
        }.store(in: &cancellables)
        
        // Set valid data
        viewModel.username = "TestUser"
        viewModel.selectedTier = .premium
        viewModel.setUserData()
        
        // Verify stream update
        #expect(userStream.updateUserCallCount == 1)
        #expect(userStream.updateUserArgValues.count == 1)
        let updatedUser = userStream.updateUserArgValues[0]
        #expect(updatedUser?.username == "TestUser")
        #expect(updatedUser?.tier == .premium)
        
        // Verify navigation
        #expect(navigationEvents == [.list])
        #expect(viewModel.validation == nil)
    }
    
    @Test("Should observe and update from user stream")
    func userStreamObservation() {
        let userStream = MutableUserStreamProtocolMock()
        let viewModel = HomeView.ViewModel(userStream: userStream)
        
        // Simulate user update from stream
        userStream.userSubject.send(User(username: "StreamUser", tier: .premium))
        
        #expect(viewModel.username == "StreamUser")
        #expect(viewModel.selectedTier == .premium)
    }
    
    @Test("Clear validation should reset validation message")
    func clearValidation() {
        let userStream = MutableUserStreamProtocolMock()
        let viewModel = HomeView.ViewModel(userStream: userStream)
        
        // Set initial validation error
        viewModel.setUserData() // This will set validation error for empty username
        #expect(viewModel.validation != nil)
        
        // Clear validation
        viewModel.clearValidationMessage()
        #expect(viewModel.validation == nil)
    }
}
