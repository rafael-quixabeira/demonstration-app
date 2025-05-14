//
//  HomeView.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 11/05/25.
//

import SwiftUI
import Combine
import Factory

struct HomeView: View {
    @StateObject
    private var viewModel: ViewModel = Container.shared.homeViewModel.resolve()

    @EnvironmentObject
    private var router: RootView.Router

    @State
    private var showErrorAlert: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            VStack(spacing: 16) {
                Text(NSLocalizedString("home-username-placeholder", comment: ""))
                    .font(.title)
                TextField(NSLocalizedString("home-username-label", comment: ""), text: $viewModel.username)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()

                Text(NSLocalizedString("home-tier-label", comment: ""))
                    .font(.title)
                Picker(NSLocalizedString("home-tier-label", comment: ""), selection: $viewModel.selectedTier) {
                    ForEach(viewModel.options, id: \.self) { option in
                        Text(option.localizedName)
                            .tag(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            VStack {
                ForEach(UserTierBenefit.allCases, id: \.self) { benefit in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(benefit.title)
                                .font(.subheadline)
                                .bold()
                            Text(benefit.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text(viewModel.selectedTier.benefits.contains(benefit) ? "✅" : "❌")
                            .font(.title2)
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)

            Button(action: viewModel.setUserData, label: {
                Text(NSLocalizedString("home-start-button", comment: ""))
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8.0)
            })
            .buttonBorderShape(.roundedRectangle)
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .onChange(of: viewModel.validation, initial: false) { _, newValue in
            showErrorAlert = newValue?.isEmpty == false
        }
        .alert(NSLocalizedString("validation-error-title", comment: ""), isPresented: $showErrorAlert, actions: {
            Button(
                NSLocalizedString("ok-button", comment: ""),
                role: .cancel,
                action: viewModel.clearValidationMessage
            )
        }, message: {
            Text(viewModel.validation ?? NSLocalizedString("unknown-error-message", comment: ""))
        })
        .onReceive(viewModel.navigationStream, perform: { destination in
            router.push(destination)
        })
    }
}

extension HomeView {
    class ViewModel: ObservableObject {
        private let userStream: MutableUserStreamProtocol
        private var cancellables: [AnyCancellable] = []
        private var navigateToStreamPublisher: PassthroughSubject<RootView.Screen, Never> = .init()

        public var navigationStream: AnyPublisher<RootView.Screen, Never> {
            navigateToStreamPublisher.eraseToAnyPublisher()
        }

        public var options = UserTier.allCases

        @Published
        public var username: String = ""

        @Published
        public var selectedTier: UserTier = .free

        @Published
        public var validation: String?

        init(userStream: MutableUserStreamProtocol) {
            self.userStream = userStream
            observe()
        }

        private func observe() {
            self.userStream.user.compactMap { $0 }.sink { [weak self] user in
                self?.username = user.username
                self?.selectedTier = user.tier
            }.store(in: &cancellables)
        }

        public func clearValidationMessage() {
            validation = nil
        }

        public func setUserData() {
            guard username.isEmpty == false else {
                validation = NSLocalizedString("username-required-message", comment: "")
                return
            }

            userStream.updateUser(.init(username: username, tier: selectedTier))
            navigateToStreamPublisher.send(.list)
        }
    }
}

#Preview {
    HomeView()
}
