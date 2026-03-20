//
//  AgentAction.swift
//  Apolo
//
//  Tappable button for agent actions.
//  Uses Apolo button styles (capsule, borderedProminentStyle).
//

import SwiftUI

// MARK: - Agent Action Style

public enum AgentActionStyle {
    case primary
    case secondary
    case destructive
}

// MARK: - Agent Action

public struct AgentAction: View {
    public let label: String
    public let icon: String?
    public let style: AgentActionStyle
    public let action: () -> Void

    public init(
        label: String,
        icon: String? = nil,
        style: AgentActionStyle = .primary,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.icon = icon
        self.style = style
        self.action = action
    }

    public var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: Tokens.Spacing.extraSmall) {
                if let icon {
                    Image(systemName: icon)
                        .regular()
                }
                Text(label)
                    .body()
                    .frame(maxWidth: .infinity)
            }
        }
        .modifier(ActionStyleModifier(style: style))
    }
}

// MARK: - Style Modifier

private struct ActionStyleModifier: ViewModifier {
    let style: AgentActionStyle

    func body(content: Content) -> some View {
        switch style {
        case .primary:
            content.borderedProminentStyle(color: Tokens.Color.label.color)
        case .secondary:
            content.borderedStyle(color: Tokens.Color.label.color, isClear: true)
        case .destructive:
            content.borderedProminentStyle(color: Tokens.Color.red.color)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: Tokens.Spacing.medium) {
        AgentAction(label: "Comprar Bitcoin", icon: "bitcoinsign.circle.fill", style: .primary) {}
        AgentAction(label: "Ver detalhes", icon: "arrow.right", style: .secondary) {}
        AgentAction(label: "Cancelar transferência", style: .destructive) {}
    }
    .padding()
}
