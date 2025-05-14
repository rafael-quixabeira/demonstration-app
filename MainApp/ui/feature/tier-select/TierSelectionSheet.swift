import SwiftUI
import Combine
import Factory

struct TierSelectionSheet: View {
    @EnvironmentObject
    private var router: RootView.Router
    
    @StateObject
    private var viewModel: ViewModel = Container.shared.tierSelectionViewModel.resolve()
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text(Strings.tierSheetGreeting(viewModel.username))
                        .font(.title)
                        .bold()
                    
                    Text(Strings.tierSheetChangeLabel)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Picker(Strings.homeTierLabel, selection: $viewModel.selectedTier) {
                    ForEach(UserTier.allCases, id: \.self) { tier in
                        Text(tier.localizedName)
                            .tag(tier)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
        }
        .onChange(of: viewModel.selectedTier) { _, newTier in
            viewModel.updateUserTier()
            router.dismissSheet()
        }
        .presentationDetents([.height(200)])
        .presentationDragIndicator(.visible)
    }
}

extension TierSelectionSheet {
    class ViewModel: ObservableObject {
        private let userStream: MutableUserStreamProtocol
        private var cancellables: [AnyCancellable] = []
        
        @Published
        public var username: String = ""
        
        @Published
        public var selectedTier: UserTier = .free
        
        init(userStream: MutableUserStreamProtocol) {
            self.userStream = userStream
            observe()
        }
        
        private func observe() {
            userStream.user
                .compactMap { $0 }
                .sink { [weak self] user in
                    self?.username = user.username
                    self?.selectedTier = user.tier
                }
                .store(in: &cancellables)
        }
        
        public func updateUserTier() {
            userStream.updateUser(.init(
                username: username,
                tier: selectedTier
            ))
        }
    }
}

#Preview {
    TierSelectionSheet()
} 
