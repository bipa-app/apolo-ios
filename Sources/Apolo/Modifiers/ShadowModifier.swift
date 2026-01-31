//
//  ShadowModifier.swift
//  Apolo
//
//  Created by Apolo on 2025.
//

import SwiftUI

public struct ShadowModifier: ViewModifier {
    let shadow: Tokens.Shadow
    let color: Color

    public init(shadow: Tokens.Shadow, color: Color = .black) {
        self.shadow = shadow
        self.color = color
    }

    public func body(content: Content) -> some View {
        content
            .shadow(
                color: color.opacity(shadow.opacity),
                radius: shadow.radius,
                x: 0,
                y: shadow.y
            )
    }
}

public extension View {
    func shadow(_ shadow: Tokens.Shadow, color: Color = .black) -> some View {
        modifier(ShadowModifier(shadow: shadow, color: color))
    }
}

#Preview {
    VStack(spacing: Tokens.Spacing.extraLarge) {
        RoundedRectangle(cornerRadius: Tokens.CornerRadius.medium)
            .fill(.background)
            .frame(width: 200, height: 100)
            .shadow(.small)

        RoundedRectangle(cornerRadius: Tokens.CornerRadius.medium)
            .fill(.background)
            .frame(width: 200, height: 100)
            .shadow(.medium)

        RoundedRectangle(cornerRadius: Tokens.CornerRadius.medium)
            .fill(.background)
            .frame(width: 200, height: 100)
            .shadow(.large)
    }
    .padding(Tokens.Spacing.extraLarge)
    .background(Color(.secondarySystemBackground))
}
