//
//  Background.swift
//  Apolo
//
//  Created by Ramon Santos on 13/01/25.
//

import Foundation
import SwiftUI
import UIKit

// MARK: CardBackground

public struct CardBackground: View {

    public var style: Style?
    public var color: Color
    public var cornerRadius: CGFloat
    
    public init(_ style: Style = .primary, cornerRadius: CGFloat = Tokens.CornerRadius.large) {
        self.style = style
        self.color = style.color
        self.cornerRadius = cornerRadius
    }
    
    public init(color: Color, cornerRadius: CGFloat = Tokens.CornerRadius.large) {
        self.color = color
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        if #available(iOS 26.0, *) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .glassEffect(.regular.tint(color).interactive(), in: RoundedRectangle(cornerRadius: cornerRadius))
        } else {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(color)
        }
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
                return Color(.secondarySystemGroupedBackground)
            case .secondary:
                return Color(.quaternarySystemFill)
            }
        }
    }
}

// MARK: - Modifiers

public extension View {
    func cardBackground(
        _ style: CardBackground.Style = .primary,
        cornerRadius: CGFloat = Tokens.CornerRadius.large
    ) -> some View {
        self.background(
            CardBackground(color: style.color, cornerRadius: cornerRadius)
        )
    }
    
    func cardBackground(
        color: Color,
        cornerRadius: CGFloat = Tokens.CornerRadius.large
    ) -> some View {
        self.background(
            CardBackground(color: color, cornerRadius: cornerRadius)
        )
    }
}

// MARK: - Preview

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
