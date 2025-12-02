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

    var colors: [Color] {
        type == .credit ? [Tokens.Color.violet.color, Tokens.Color.blue.color] : [Tokens.Color.green.color, Tokens.Color.mint.color]
    }
    
    var body: some View {
        Text(type == .credit ? "Crédito" : "Pré-pago")
            .caption1(weight: .italic)
            .foregroundStyle(.white)
            .padding(.vertical, Tokens.Spacing.extraExtraSmall)
            .padding(.horizontal, Tokens.Spacing.small)
            .background(
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: phase == 0 ? colors.reversed() : colors,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .clipShape(.capsule)
            .task {
                withAnimation(.linear(duration: 10).repeatForever(autoreverses: true)) {
                    phase = 1
                }
            }
    }
}

// MARK: - Preview

#Preview {
    CardTag(type: .prepaid)
}

