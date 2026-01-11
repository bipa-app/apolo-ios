//
//  CardTag.swift
//  Apolo
//
//  Created by Lucas Farah on 02/12/25.
//

import SwiftUI

#if !os(watchOS)

// MARK: CardTag

struct CardTag: View {
    let type: Tag.Style.CardType
    @State private var phase: CGFloat = 0

    var colors: [Color] {
        switch type {
        case .prepaid:
            [Tokens.Color.green.color, Tokens.Color.mint.color]
        case .credit:
            [Tokens.Color.violet.color, Tokens.Color.blue.color]
        }
    }
    
    var foregroundColor: Color {
        switch type {
        case let .prepaid(isTurbo, false):
            isTurbo ? .white : Tokens.Color.systemBackground.color
        case .prepaid(_, true):
            .black
        case let .credit(_, isPremium):
            isPremium ? .black : .white
        }
    }
    
    var body: some View {
        switch type {
        case let .credit(isTurbo, isPremium), let .prepaid(isTurbo, isPremium):
            if isTurbo || isPremium {
                HStack {
                    Text(type.name)
                        .caption1(weight: .italic)
                        .foregroundStyle(foregroundColor)
                    
                    if isTurbo {
                        Image(systemName: "flame")
                            .small()
                            .foregroundStyle(foregroundColor)
                    }
                }
                .padding(.vertical, Tokens.Spacing.extraSmall)
                .padding(.horizontal, Tokens.Spacing.small)
                .background(
                    Rectangle()
                        .fill(
                            isPremium ? RadialGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 1.0, green: 0.584, blue: 0.0),
                                    Color(red: 1.0, green: 0.584, blue: 0.0),
                                    Color(red: 1.0, green: 0.7, blue: 0.0),
                                    Color(red: 1.0, green: 0.8, blue: 0.0),
                                    Color(red: 1.0, green: 0.9, blue: 0.0),
                                    Color(red: 1.0, green: 0.8, blue: 0.0)
                                ]),
                                center: .center,
                                startRadius: 0,
                                endRadius: 20
                            ) : RadialGradient(gradient: Gradient(colors: [
                                Color(red: 255/255, green: 187/255, blue: 0/255),
                                Color(red: 255/255, green: 109/255, blue: 0/255),
                                Color(red: 217/255, green: 93/255, blue: 213/255),
                                Color(red: 57/255, green: 121/255, blue: 255/255)
                            ]), center: .center, startRadius: 40, endRadius: 4)
                        )
                        .modifier(FlowEffect(phase: phase))
                        .scaleEffect(4)
                )
                .clipShape(.capsule)
                .task {
                    withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                        phase = .pi * 2
                    }
                }
            } else {
                Text(type.name)
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
    }
}

// MARK: - Preview

#Preview {
    VStack {
        CardTag(type: .prepaid(isTurbo: true, isPremium: false))
        CardTag(type: .credit(isTurbo: true, isPremium: false))
        CardTag(type: .prepaid(isTurbo: false, isPremium: false))
        CardTag(type: .credit(isTurbo: false, isPremium: false))
        CardTag(type: .prepaid(isTurbo: true, isPremium: true))
        CardTag(type: .credit(isTurbo: true, isPremium: true))
        CardTag(type: .credit(isTurbo: false, isPremium: true))
        CardTag(type: .prepaid(isTurbo: false, isPremium: true))
    }
}


#endif
