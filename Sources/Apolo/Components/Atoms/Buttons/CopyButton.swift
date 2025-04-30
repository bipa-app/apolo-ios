//
//  CopyButton.swift
//  Apolo
//
//  Created by Ramon Santos on 26/02/25.
//

import SwiftUI

// MARK: CopyButton

public struct CopyButton: View {
    public init(
        value: String,
        successColor: Color = .green,
        onCopied: ((String) -> Void)? = nil
    ) {
        self.value = value
        self.successColor = successColor
        self.onCopied = onCopied
    }

    private let value: String
    private let successColor: Color
    private let onCopied: ((String) -> Void)?
    @State private var copied = false

    public var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            UIPasteboard.general.string = value
            onCopied?(value)

            withAnimation { copied = true }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation { copied = false }
            }
        }, label: {
            if #available(iOS 18.0, *) {
                ZStack(alignment: .center) {
                    Image(systemName: "square.on.square")
                        .hidden()
                        .accessibilityHidden(true)

                    Image(systemName: copied ? "checkmark" : "square.on.square")
                        .foregroundStyle(copied ? successColor : .primary)
                        .contentTransition(
                            .symbolEffect(
                                .replace.magic(fallback: .downUp.byLayer),
                                options: .nonRepeating
                            )
                        )
            }
            } else {
                Image(systemName: copied ? "checkmark" : "square.on.square")
                    .foregroundStyle(copied ? successColor : .primary)
                    .transition(.opacity)
            }
        })
        .accessibilityLabel("Botão de copiar")
        .accessibilityHint("Toque para copiar o texto")
        .accessibilityValue(value)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: Tokens.Spacing.medium) {
        CopyButton(value: "Nice animation!") { value in
            print("Copied value is: \(value)")
        }

        CopyButton(value: "Nice animation!", successColor: Color(.violet)) { value in
            print("Copied value is: \(value)")
        }
    }
}
