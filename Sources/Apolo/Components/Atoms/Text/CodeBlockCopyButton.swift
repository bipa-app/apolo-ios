//
//  CodeBlockCopyButton.swift
//  Apolo
//
//  Copyright © 2026 Bipa. All rights reserved.
//

import SwiftUI

// MARK: - Code Block Copy Button

/// A compact copy button for code blocks within markdown rendering.
/// Provides haptic feedback and a checkmark confirmation animation.
struct CodeBlockCopyButton: View {
    let action: () -> Void

    @State private var copied = false
    @ScaledMetric private var size: CGFloat = 20

    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            action()
            withAnimation { copied = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation { copied = false }
            }
        } label: {
            if #available(iOS 18.0, *) {
                image
                    .contentTransition(.symbolEffect(.replace.magic(fallback: .downUp.byLayer), options: .nonRepeating))
            } else {
                image
                    .transition(.opacity)
            }
        }
        .accessibilityLabel("Copiar código")
        .accessibilityHint("Toque para copiar o conteúdo do bloco de código")
    }

    private var image: some View {
        Image(systemName: copied ? "checkmark" : "square.on.square")
            .foregroundStyle(copied ? Tokens.Color.green.color : Tokens.Color.secondaryLabel.color)
            .font(.system(size: 14))
            .frame(width: size, height: size)
            .contentShape(.rect)
    }
}
