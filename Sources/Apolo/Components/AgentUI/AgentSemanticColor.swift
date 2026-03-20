//
//  AgentSemanticColor.swift
//  Apolo
//
//  Semantic color mapping for agent UI components.
//  Adapts automatically to light/dark mode via Apolo Tokens.
//

import SwiftUI

// MARK: - Agent Semantic Color

public enum AgentSemanticColor: String, CaseIterable {
    /// Bitcoin / BTC — Violet
    case bitcoin
    /// Brazilian Real / BRL — Green
    case real
    /// USDT / stablecoins — Cyan
    case dollar
    /// Credit card / Bipa Card — Blue
    case card
    /// Gains, income, success — Green
    case positive
    /// Losses, expenses, errors — Red
    case negative
    /// Pending, attention — Yellow
    case warning
    /// Default, no semantic meaning — adapts to label (black/white)
    case neutral
    /// Brand accent / primary action — Label (black in light, white in dark)
    case accent

    public var color: Color {
        switch self {
        case .bitcoin:  Tokens.Color.violet.color
        case .real:     Tokens.Color.green.color
        case .dollar:   Tokens.Color.cyan.color
        case .card:     Tokens.Color.blue.color
        case .positive: Tokens.Color.green.color
        case .negative: Tokens.Color.red.color
        case .warning:  Tokens.Color.yellow.color
        case .neutral:  Tokens.Color.label.color
        case .accent:   Tokens.Color.label.color
        }
    }

    /// Resolve from a string name (used by the DSL renderer).
    /// Falls back to `.neutral` for unknown names.
    public static func from(_ name: String?) -> AgentSemanticColor {
        guard let name else { return .neutral }
        return AgentSemanticColor(rawValue: name) ?? legacyMapping(name)
    }

    /// Maps legacy raw color names to semantic colors.
    private static func legacyMapping(_ name: String) -> AgentSemanticColor {
        switch name {
        case "violet", "purple":  .accent
        case "green":             .positive
        case "red":               .negative
        case "yellow":            .warning
        case "blue":              .card
        case "mint", "teal", "cyan": .dollar
        case "orange":            .bitcoin
        default:                  .neutral
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: Tokens.Spacing.medium) {
        ForEach(AgentSemanticColor.allCases, id: \.rawValue) { semantic in
            HStack {
                Circle()
                    .fill(semantic.color)
                    .frame(width: 24, height: 24)
                Text(semantic.rawValue)
                    .callout()
                Spacer()
            }
        }
    }
    .padding()
}
