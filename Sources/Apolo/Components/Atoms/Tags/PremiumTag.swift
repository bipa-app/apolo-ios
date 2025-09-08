//
//  PremiumTag.swift
//  Apolo
//
//  Created by Ramon Santos on 04/09/25.
//

import SwiftUI

// MARK: PremiumTag

struct PremiumTag: View {
    @State private var phase: CGFloat = 0

    var body: some View {
        Text("Premium")
            .bradford(italic: true)
            .foregroundStyle(.black)
            .padding(.vertical, Tokens.Spacing.extraSmall)
            .padding(.horizontal, Tokens.Spacing.small)
            .background(
                Rectangle()
                    .fill(
                        RadialGradient(
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
    PremiumTag()
}
