//
//  AgentText.swift
//  Apolo
//
//  Styled text block for agent commentary within UI blocks.
//

import SwiftUI

// MARK: - Agent Text

public struct AgentText: View {
    public let content: String
    public let style: Style

    public enum Style {
        /// Body text — primary color, regular weight
        case body
        /// Caption — secondary color, smaller
        case caption
        /// Headline — primary color, medium weight
        case headline
    }

    public init(_ content: String, style: Style = .body) {
        self.content = content
        self.style = style
    }

    public var body: some View {
        switch style {
        case .body:
            Text(content)
                .body()
                .foregroundStyle(Tokens.Color.label.color)
        case .caption:
            Text(content)
                .caption1()
                .foregroundStyle(Tokens.Color.secondaryLabel.color)
        case .headline:
            Text(content)
                .callout(weight: .medium)
                .foregroundStyle(Tokens.Color.label.color)
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: Tokens.Spacing.small) {
        AgentText("Seu portfólio valorizou 34% — isso é excelente!", style: .body)
        AgentText("Baseado nos últimos 30 dias", style: .caption)
        AgentText("Resumo do mês", style: .headline)
    }
    .padding()
}
