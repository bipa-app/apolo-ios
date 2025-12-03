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
    
    var colors: [Color] {
        type == .credit ? [Tokens.Color.violet.color, Tokens.Color.blue.color] : [Tokens.Color.green.color, Tokens.Color.mint.color]
    }
    
    var foregroundColor: Color {
        type == .credit ? .white : Tokens.Color.systemBackground.color
    }
    
    var body: some View {
        Text(type == .credit ? "Crédito" : "Pré-pago")
            .caption1(weight: .italic)
            .foregroundStyle(foregroundColor)
            .padding(.vertical, Tokens.Spacing.extraSmall)
            .padding(.horizontal, Tokens.Spacing.small)
            .background(
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: colors,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .clipShape(.capsule)
    }
}

// MARK: - Preview

#Preview {
    CardTag(type: .prepaid)
}

