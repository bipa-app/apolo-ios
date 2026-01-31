//
//  Tag.swift
//  Apolo
//
//  Created by Devin on 11/12/24.
//

import SwiftUI

// MARK: Tag

public struct Tag: View {
    // MARK: - Size

    public enum Size {
        case small
        case regular

        func applyTypography<V: View>(_ view: V) -> AnyView {
            switch self {
            case .small:
                return AnyView(view.caption2())
            case .regular:
                return AnyView(view.subheadline())
            }
        }

        var verticalPadding: CGFloat {
            switch self {
            case .small: return Tokens.Spacing.extraExtraSmall
            case .regular: return Tokens.Spacing.extraSmall
            }
        }

        var horizontalPadding: CGFloat {
            switch self {
            case .small: return Tokens.Spacing.extraSmall
            case .regular: return Tokens.Spacing.small
            }
        }
    }

    // MARK: - Style

    public enum Style: Equatable {
        case label(icon: String? = nil)
        case success
        case warning
        case error
        case turbo
        case custom(
            backgroundColor: Color,
            textColor: Color,
            icon: String? = nil,
            secondaryIcon: String? = nil
        )

        var icon: String? {
            switch self {
            case let .label(icon): icon
            case .success: "checkmark.circle.fill"
            case .warning: "clock.fill"
            case .error: "exclamationmark.triangle.fill"
            case .turbo: nil
            case let .custom(_, _, icon, _): icon
            }
        }

        var secondaryIcon: String? {
            switch self {
            case .label, .success, .warning, .error, .turbo: nil
            case let .custom(_, _, _, icon): icon
            }
        }

        var textColor: Color {
            switch self {
            case let .custom(_, textColor, _, _): textColor
            case .label: .primary
            case .turbo: .white
            default: Color(uiColor: .systemBackground)
            }
        }

        var backgroundColor: Color {
            switch self {
            case .label: .clear
            case .success: .green
            case .warning: .yellow
            case .error: .red
            case .turbo: .clear
            case let .custom(backgroundColor, _, _, _): backgroundColor
            }
        }
    }

    // MARK: - Properties

    private let style: Style
    private let title: String?
    private let size: Size

    // MARK: - Initialization

    public init(style: Style = .label(), size: Size = .regular) {
        self.style = style
        title = nil
        self.size = size
    }

    public init(style: Style = .label(), title: String, size: Size = .regular) {
        self.style = style
        self.title = title
        self.size = size
    }

    // MARK: - Body

    public var body: some View {
        if case .turbo = style {
            TurboTag()
        } else if let title {
            PlainTag(style: style, title: title, size: size)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(alignment: .leading, spacing: Tokens.Spacing.medium) {
        Group {
            Text("Regular Size")
                .headline()

            Tag(style: .label(icon: "bitcoinsign.circle.fill"), title: "LABEL")
            Tag(style: .success, title: "CONCLUÍDA")
            Tag(style: .warning, title: "PENDENTE")
            Tag(style: .error, title: "FALHADA")
            Tag(style: .custom(backgroundColor: Color(uiColor: .quaternarySystemFill), textColor: .secondary), title: "Crédito Virtual")
            Tag(style: .turbo)
            Tag(style: .custom(backgroundColor: .indigo, textColor: .mint), title: "Custom")

            Tag(
                style: .custom(
                    backgroundColor: Tokens.Color.violet.color.opacity(0.15),
                    textColor: Tokens.Color.violet.color,
                    icon: "bitcoinsign.circle.fill",
                    secondaryIcon: "chevron.down"
                ),
                title: "Bitcoin",
                size: .regular
            )
        }

        Divider()

        Group {
            Text("Small Size")
                .headline()

            Tag(style: .label(icon: "bitcoinsign.circle.fill"), title: "LABEL", size: .small)
            Tag(style: .success, title: "CONCLUÍDA", size: .small)
            Tag(style: .warning, title: "PENDENTE", size: .small)
            Tag(style: .error, title: "FALHADA", size: .small)
            Tag(style: .custom(backgroundColor: Color(uiColor: .quaternarySystemFill), textColor: .secondary), title: "Crédito Virtual", size: .small)
            Tag(style: .custom(backgroundColor: .indigo, textColor: .mint), title: "Custom", size: .small)

            Tag(
                style: .custom(
                    backgroundColor: Tokens.Color.violet.color.opacity(0.15),
                    textColor: Tokens.Color.violet.color,
                    icon: "bitcoinsign.circle.fill",
                    secondaryIcon: "chevron.down"
                ),
                title: "Bitcoin",
                size: .small
            )
        }
    }
    .padding()
}
