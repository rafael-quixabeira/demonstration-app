//
//  ErrorOverlayModifier.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 10/05/25.
//

import SwiftUI

import SwiftUI

struct ErrorOverlayModifier: ViewModifier {
    let show: Bool
    let message: String
    let retry: () -> Void

    func body(content: Content) -> some View {
        content
            .overlay {
                if show {
                    Color.clear.opacity(0.4)
                        .overlay {
                            VStack(spacing: 16) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.black)

                                Text(message)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.black)
                                    .padding(.horizontal)

                                Button(NSLocalizedString("try-again-button", comment: ""), action: retry)
                                    .buttonStyle(.bordered)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 8)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                    .cornerRadius(8)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.white.opacity(0.5))
                        }
                }
            }
    }
}

extension View {
    func errorOverlay(show: Bool, message: String, retry: @escaping () -> Void) -> some View {
        self.modifier(
            ErrorOverlayModifier(show: show, message: message, retry: retry)
        )
    }
}
