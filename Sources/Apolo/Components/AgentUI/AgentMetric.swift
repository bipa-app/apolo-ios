//
//  AgentMetric.swift
//  Apolo
//
//  Hero number with label, caption, and icon.
//  Used for balances, prices, PnL, limits, cashback amounts.
//

import SwiftUI

// MARK: - Agent Metric

public struct AgentMetric: View {
    public let label: String
    public let value: String
    public let caption: String?
    public let captionColor: Color?
    public let icon: String?
    public let iconColor: Color?

    public init(
        label: String,
        value: String,
        caption: String? = nil,
        captionColor: Color? = nil,
        icon: String? = nil,
        iconColor: Color? = nil
    ) {
        self.label = label
        self.value = value
        self.caption = caption
        self.captionColor = captionColor
        self.icon = icon
        self.iconColor = iconColor
    }

    public var body: some View {
        HStack(spacing: Tokens.Spacing.small) {
            if let icon {
                Image(systemName: icon)
                    .large()
                    .foregroundStyle(iconColor ?? Tokens.Color.label.color)
            }

            VStack(alignment: .leading, spacing: Tokens.Spacing.extraExtraSmall) {
                Text(label)
                    .subheadline()
                    .foregroundStyle(Tokens.Color.secondaryLabel.color)

                Text(value)
                    .title3(weight: .medium)
                    .foregroundStyle(Tokens.Color.label.color)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .monospacedDigit()

                if let caption {
                    Text(caption)
                        .caption1()
                        .foregroundStyle(captionColor ?? Tokens.Color.secondaryLabel.color)
                        .monospacedDigit()
                }
            }

            Spacer(minLength: 0)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: Tokens.Spacing.medium) {
        AgentMetric(
            label: "Bitcoin",
            value: "R$ 374.438",
            caption: "+0.8%",
            captionColor: Tokens.Color.green.color,
            icon: "bitcoinsign.circle.fill",
            iconColor: Tokens.Color.violet.color
        )

        AgentMetric(
            label: "Dólar",
            value: "$ 85,03",
            icon: "dollarsign.circle.fill",
            iconColor: Tokens.Color.mint.color
        )

        AgentMetric(
            label: "Fatura fechada",
            value: "R$ 3.456,00",
            caption: "Vence 10/04",
            captionColor: Tokens.Color.yellow.color,
            icon: "creditcard.fill",
            iconColor: Tokens.Color.violet.color
        )
    }
    .padding()
}
