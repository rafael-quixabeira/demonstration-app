import Testing
import Combine
@testable import MainApp

struct TierSelectionSheetTest {
    // Store for cancellables to prevent premature deallocation
    private var cancellables: Set<AnyCancellable> = []

    @Test("Initial state should have default values")
    func initialState() {
        let userStream = MutableUserStreamProtocolMock()
        let viewModel = TierSelectionSheet.ViewModel(userStream: userStream)
        
        #expect(viewModel.username.isEmpty)
        #expect(viewModel.selectedTier == .free)
    }

    @Test("Should observe and update from user stream")
    func userStreamObservation() {
        let userStream = MutableUserStreamProtocolMock()
        let viewModel = TierSelectionSheet.ViewModel(userStream: userStream)
        
        // Simulate initial user data from stream
        let testUser = User(username: "TestUser", tier: .premium)
        userStream.userSubject.send(testUser)
        
        #expect(viewModel.username == "TestUser")
        #expect(viewModel.selectedTier == .premium)
    }

    @Test("Should update user tier when requested")
    func updateUserTier() {
        let userStream = MutableUserStreamProtocolMock()
        let viewModel = TierSelectionSheet.ViewModel(userStream: userStream)
        
        // Setup initial state via stream
        userStream.userSubject.send(User(username: "InitialUser", tier: .free))
        
        // Change tier and trigger update
        viewModel.selectedTier = .premium
        viewModel.updateUserTier()
        
        // Verify the update was called with correct data
        #expect(userStream.updateUserCallCount == 1)
        #expect(userStream.updateUserArgValues.count == 1)
        
        let updatedUser = userStream.updateUserArgValues[0]
        #expect(updatedUser?.username == "InitialUser")
        #expect(updatedUser?.tier == .premium)
    }

    @Test("Should maintain user data consistency across multiple updates")
    func userDataConsistency() {
        let userStream = MutableUserStreamProtocolMock()
        let viewModel = TierSelectionSheet.ViewModel(userStream: userStream)
        
        // Simulate sequence of updates
        let updates = [
            User(username: "User1", tier: .free),
            User(username: "User1", tier: .premium),
            User(username: "User1", tier: .free)
        ]
        
        for user in updates {
            userStream.userSubject.send(user)
            #expect(viewModel.username == user.username)
            #expect(viewModel.selectedTier == user.tier)
        }
    }
    
    @Test("Should handle all possible tier selections")
    func tierSelectionHandling() {
        let userStream = MutableUserStreamProtocolMock()
        let viewModel = TierSelectionSheet.ViewModel(userStream: userStream)
        
        // Set initial user
        userStream.userSubject.send(User(username: "TestUser", tier: .free))
        
        // Test all tier transitions
        for tier in UserTier.allCases {
            viewModel.selectedTier = tier
            viewModel.updateUserTier()
            
            let lastUpdate = userStream.updateUserArgValues.last
            #expect(lastUpdate??.tier == tier)
        }
        
        #expect(userStream.updateUserCallCount == UserTier.allCases.count)
    }
}
