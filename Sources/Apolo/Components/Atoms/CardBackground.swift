//
//  Background.swift
//  Apolo
//
//  Created by Ramon Santos on 13/01/25.
//

import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: CardBackground

public struct CardBackground: View {

    public var style: Style?
    public var color: Color
    public var cornerRadius: CGFloat
    public var glassEnabled: Bool
    public var glassInteractive: Bool

    public init(
        _ style: Style = .primary,
        cornerRadius: CGFloat = Tokens.CornerRadius.large,
        glassEnabled: Bool = true,
        glassInteractive: Bool = true
    ) {
        self.style = style
        self.color = style.color
        self.cornerRadius = cornerRadius
        self.glassEnabled = glassEnabled
        self.glassInteractive = glassInteractive
    }

    public init(
        color: Color,
        cornerRadius: CGFloat = Tokens.CornerRadius.large,
        glassEnabled: Bool = true,
        glassInteractive: Bool = true
    ) {
        self.color = color
        self.cornerRadius = cornerRadius
        self.glassEnabled = glassEnabled
        self.glassInteractive = glassInteractive
    }

    public var body: some View {
        #if os(iOS)
        if #available(iOS 26.0, *), glassEnabled {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(color)
                .glassEffect(.clear.interactive(glassInteractive), in: RoundedRectangle(cornerRadius: cornerRadius))
        } else {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(color)
        }
        #else
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(color)
        #endif
    }
}

// MARK: - Style

public extension CardBackground {
    enum Style {
        case primary
        case secondary

        var color: Color {
            switch self {
            case .primary:
                #if os(watchOS)
                return Color.black.opacity(0.3)
                #else
                return Color(.secondarySystemGroupedBackground)
                #endif
            case .secondary:
                #if os(watchOS)
                return Color.gray.opacity(0.15)
                #else
                return Color(.quaternarySystemFill)
                #endif
            }
        }
    }
}

// MARK: - Modifiers

public extension View {
    func cardBackground(
        _ style: CardBackground.Style = .primary,
        cornerRadius: CGFloat = Tokens.CornerRadius.large,
        glassEnabled: Bool = true,
        glassInteractive: Bool = true
    ) -> some View {
        self.background(
            CardBackground(color: style.color, cornerRadius: cornerRadius, glassEnabled: glassEnabled, glassInteractive: glassInteractive)
        )
    }

    func cardBackground(
        color: Color,
        cornerRadius: CGFloat = Tokens.CornerRadius.large,
        glassEnabled: Bool = true,
        glassInteractive: Bool = true
    ) -> some View {
        self.background(
            CardBackground(color: color, cornerRadius: cornerRadius, glassEnabled: glassEnabled, glassInteractive: glassInteractive)
        )
    }
}

// MARK: - Preview

#if !os(watchOS)
#Preview {
    VStack {
        Text("Primary")
            .padding()
            .cardBackground()

        Text("Secondary")
            .padding()
            .cardBackground(.secondary)

        Text("Custom Color")
            .padding()
            .cardBackground(color: .yellow)

        Button(action: {}, label: {
            Text("Button with Primary")
                .padding()
                .cardBackground(.primary)
        })

        Label("Label", systemImage: "gear")
            .padding()
            .background(CardBackground())

        VStack(alignment: .leading, spacing: Tokens.Spacing.extraExtraSmall) {
            Group {
                Text("Liberação do Satsback®")
                    .callout(weight: .bold)
                    .foregroundStyle(Tokens.Color.label.color)

                Text("Seu Satsback® ficará disponível para resgate após o fechamento e pagamento da primeira fatura do seu cartão de crédito.")
                    .subheadline()
                    .foregroundStyle(Tokens.Color.secondaryLabel.color)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardBackground(.secondary)
        .padding(.horizontal, Tokens.Spacing.medium)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .cardBackground(color: .secondary)
    .padding()
    .tint(.primary)
}
#endif
