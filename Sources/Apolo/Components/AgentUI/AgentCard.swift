//
//  AgentCard.swift
//  Apolo
//
//  Glass card container with optional title and icon.
//  The primary container for grouping agent UI components.
//

import SwiftUI

// MARK: - Agent Card

public struct AgentCard<Content: View>: View {
    public let title: String?
    public let icon: String?
    public let iconColor: Color?
    public let style: CardBackground.Style
    @ViewBuilder public let content: () -> Content

    public init(
        title: String? = nil,
        icon: String? = nil,
        iconColor: Color? = nil,
        style: CardBackground.Style = .primary,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.icon = icon
        self.iconColor = iconColor
        self.style = style
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.medium) {
            if title != nil || icon != nil {
                HStack(spacing: Tokens.Spacing.extraSmall) {
                    if let icon {
                        Image(systemName: icon)
                            .large()
                            .foregroundStyle(iconColor ?? AgentSemanticColor.accent.color)
                    }

                    if let title {
                        Text(title)
                            .callout(weight: .medium)
                            .foregroundStyle(Tokens.Color.label.color)
                    }
                }
            }

            content()
        }
        .padding(Tokens.Spacing.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardBackground(style)
    }
}



// MARK: - Previews

#Preview("Card with title") {
    AgentCard(title: "Portfólio Bitcoin", icon: "bitcoinsign.circle.fill", iconColor: Tokens.Color.violet.color) {
        AgentMetric(label: "Valor atual", value: "R$ 3.720.523", caption: "+34.5%", captionColor: Tokens.Color.green.color)
        AgentChart(style: .progress, data: [0.62], color: Tokens.Color.green.color)
        AgentTable(rows: [
            .init(label: "Investido", value: "R$ 2.500.000"),
            .init(label: "Lucro", value: "R$ 1.220.523"),
        ])
    }
    .padding()
}

#Preview("Card simple") {
    AgentCard {
        AgentMetric(label: "Bitcoin", value: "5.200.000 sats", caption: "~R$ 3.720.523", icon: "bitcoinsign.circle.fill", iconColor: Tokens.Color.violet.color)
        AgentMetric(label: "Dólar", value: "$ 85,03", icon: "dollarsign.circle.fill", iconColor: Tokens.Color.mint.color)
        AgentMetric(label: "Reais", value: "R$ 12.345,67", icon: "brazilianrealsign.circle.fill", iconColor: Tokens.Color.green.color)
    }
    .padding()
}

#Preview("Document Preview") {
    AgentDocumentPreview(title: "Relatório de gastos — Março 2026", preview: "R$ 4.523,00 em 47 transações") {
        VStack(spacing: Tokens.Spacing.medium) {
            AgentCard {
                AgentMetric(label: "Total gasto", value: "R$ 4.523,00", caption: "+12% vs fevereiro", captionColor: Tokens.Color.red.color)
            }
            AgentCard(title: "Por categoria") {
                AgentList(items: [
                    .init(title: "Alimentação", subtitle: "23 transações", trailing: "R$ 1.200", icon: "fork.knife"),
                    .init(title: "Transporte", subtitle: "12 transações", trailing: "R$ 800", icon: "car.fill"),
                ], maxVisible: 10)
            }
        }
    }
    .padding()
}
