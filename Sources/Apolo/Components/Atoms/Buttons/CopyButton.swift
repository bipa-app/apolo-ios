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
        onCopied: ((String) -> Void)? = nil
    ) {
        self.value = value
        self.onCopied = onCopied
    }
    
    private let value: String
    private let onCopied: ((String) -> Void)?
    @State private var copied = false

    public var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            UIPasteboard.general.string = value
            onCopied?(value)
            
            withAnimation { copied = true }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation { copied = false }
            }
        }, label: {
            if #available(iOS 18.0, *) {
                Image(systemName: copied ? "checkmark" : "square.on.square")
                    .foregroundStyle(copied ? .green : .primary)
                    .contentTransition(
                        .symbolEffect(
                            .replace.magic(fallback: .downUp.byLayer),
                            options: .nonRepeating
                        )
                    )
            } else {
                Image(systemName: copied ? "checkmark" : "square.on.square")
                    .foregroundStyle(copied ? .green : .primary)
                    .transition(.opacity)
            }
        })
    }
}

// MARK: - Preview

#Preview {
    CopyButton(value: "Nice animation!") { value in
        print("Copied value is: \(value)")
    }
}
