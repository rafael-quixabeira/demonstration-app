//
//  RootView.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 11/05/25.
//

import SwiftUI

struct RootView: View {
    @StateObject
    private var router = Router()

    var body: some View {
        NavigationStack(path: $router.path) {
            build(screen: .home)
            .navigationDestination(for: RootView.Screen.self, destination: { screen in
                build(screen: screen)
            })
            .sheet(item: $router.sheet) { sheet in
                build(sheet: sheet)
            }
        }
        .environmentObject(router)
    }

    @ViewBuilder
    fileprivate func build(screen: Screen) -> some View {
        switch screen {
        case .home:
            HomeView()
        case .list:
            CharacterListView()
        case .detail(let id):
            CharacterDetailView(characterID: id)
        }
    }

    @ViewBuilder
    fileprivate func build(sheet: Sheet) -> some View {
        switch sheet {
        case .tierSelect:
            TierSelectionSheet()
        }
    }
}

extension RootView {
    class Router: ObservableObject {
        @Published var path: NavigationPath = NavigationPath()
        @Published var sheet: Sheet?

        func push(_ screen: Screen) {
            path.append(screen)
        }

        func pop() {
            path.removeLast()
        }

        func popToRoot() {
            path.removeLast(path.count)
        }

        func presentSheet(_ sheet: Sheet) {
            self.sheet = sheet
        }

        func dismissSheet() {
            sheet = nil
        }
    }
}

extension RootView {
    enum Screen: Identifiable, Hashable {
        case home
        case list
        case detail(id: String)

        var id: Self { self }
    }

    enum Sheet: Identifiable, Hashable {
        case tierSelect

        var id: Self { self }
    }
}
