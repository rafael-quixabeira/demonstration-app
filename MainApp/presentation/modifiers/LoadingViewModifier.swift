//
//  LoadingViewModifier.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 10/05/25.
//

import SwiftUI

struct LoadingViewModifier: ViewModifier {
    let isLoading: Bool

    func body(content: Content) -> some View {
        content
            .disabled(isLoading)
            .blur(radius: isLoading ? 3 : 0)
            .overlay {
                if isLoading {
                    Color.clear.overlay {
                        ProgressView(Strings.loadingMessage)
                            .controlSize(.large)
                            .progressViewStyle(CircularProgressViewStyle(tint: .black.opacity(0.75)))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .foregroundStyle(.black.opacity(0.75))
                    }
                }
            }
    }
}

extension View {
    func loadingOverlay(_ isLoading: Bool) -> some View {
        self.modifier(LoadingViewModifier(isLoading: isLoading))
    }
}
