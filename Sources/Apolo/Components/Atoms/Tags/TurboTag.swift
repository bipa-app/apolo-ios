//
//  TurboTag.swift
//  Apolo
//
//  Created by Eric on 26/12/24.
//

import SwiftUI

// MARK: Turbo Tag

struct TurboTag: View {
    @State private var phase: CGFloat = 0

    var body: some View {
        HStack(spacing: Tokens.Spacing.extraExtraSmall) {
            Text("Bipa")
                .subheadline()
            Text("Turbo")
                .subheadline()
                .fontWeight(.medium)
                .italic()
        }
        .foregroundStyle(.white)
        .padding(.vertical, Tokens.Spacing.extraSmall)
        .padding(.horizontal, Tokens.Spacing.small)
        .background(
            Rectangle()
                .fill(RadialGradient(gradient: Gradient(colors: [
                    Color(red: 255/255, green: 187/255, blue: 0/255),
                    Color(red: 255/255, green: 109/255, blue: 0/255),
                    Color(red: 217/255, green: 93/255, blue: 213/255),
                    Color(red: 57/255, green: 121/255, blue: 255/255)
                ]), center: .center, startRadius: 40, endRadius: 4))
                .modifier(FlowEffect(phase: phase))
                .scaleEffect(4)
        )
        .clipShape(.capsule)
        .onAppear {
            withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                phase = .pi * 2
            }
        }
    }
}

// MARK: Animation

private struct FlowEffect: GeometryEffect {
    var phase: CGFloat

    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        let transform = CGAffineTransform(
            a: 1 + sin(phase) * 0.3,
            b: cos(phase * 2) * 0.1,
            c: sin(phase * 2) * 0.1,
            d: 1 + cos(phase) * 0.2,
            tx: sin(phase) * 5,
            ty: cos(phase) * 5
        )
        return ProjectionTransform(transform)
    }
}

// MARK: - Preview

#Preview {
    TurboTag()
}
