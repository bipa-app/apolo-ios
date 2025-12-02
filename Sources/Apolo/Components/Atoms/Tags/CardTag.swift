//
//  CardTag.swift
//  Apolo
//
//  Created by Lucas Farah on 02/12/25.
//

import SwiftUI

// MARK: CardTag

struct CardTag: View {
    let type: Tag.Style.CardType
    
    @State private var phase: CGFloat = 0

    var body: some View {
        Text(type == .credit ? "Crédito" : "Pré-pago")
            .body(weight: .italic)
            .foregroundStyle(.white)
            .padding(.vertical, Tokens.Spacing.extraSmall)
            .padding(.horizontal, Tokens.Spacing.small)
            .background(
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: type == .credit ? [Tokens.Color.violet.color, Tokens.Color.blue.color] : [Tokens.Color.green.color, Tokens.Color.mint.color],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .modifier(FlowEffect(phase: phase))
                    .scaleEffect(4)
            )
            .clipShape(.capsule)
            .task {
                withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                    phase = .pi * 2
                }
            }
    }
}

// MARK: - Preview

#Preview {
    CardTag(type: .prepaid)
}

