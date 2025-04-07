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

    public enum Style: Equatable, Identifiable {
        case label(icon: String? = nil)
        case success
        case warning
        case error
        case turbo
        case custom(
            shapeStyle: (any ShapeStyle)? = nil,
            backgroundColor: Color = .clear,
            textColor: Color = .primary,
            icon: String? = nil,
            secondaryIcon: String? = nil
        )
        
        public var id: UUID { .init() }
        
        public static func == (lhs: Tag.Style, rhs: Tag.Style) -> Bool {
            return lhs.id == rhs.id
        }
        
        var icon: String? {
            switch self {
            case let .label(icon): icon
            case .success: "checkmark.circle.fill"
            case .warning: "clock.fill"
            case .error: "exclamationmark.triangle.fill"
            case .turbo: nil
            case let .custom(_, _, _, icon, _): icon
            }
        }

        var secondaryIcon: String? {
            switch self {
            case .label, .success, .warning, .error, .turbo: nil
            case let .custom(_, _, _, _, icon): icon
            }
        }

        var textColor: Color {
            switch self {
            case let .custom(_, _, textColor, _, _): textColor
            case .label: .primary
            case .turbo: .white
            default: Color(uiColor: .systemBackground)
            }
        }
        
        var background: AnyShapeStyle {
            switch self {
            case .label, .turbo:
                return .init(Color.clear)
            case .success:
                return .init(Color.green)
            case .warning:
                return .init(Color.yellow)
            case .error:
                return .init(Color.red)
            case let .custom(shapeStyle, backgroundColor, _, _, _):
                if let shapeStyle {
                    return .init(shapeStyle)
                }
                return .init(backgroundColor)
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
            Tag(style: .custom(backgroundColor: .indigo, textColor: .mint), title: "Custom Color")
            Tag(style: .custom(shapeStyle: .ultraThinMaterial), title: "Custom ShapeStyle")
            
            Tag(
                style: .custom(
                    backgroundColor: Color(.violet).opacity(0.15),
                    textColor: Color(.violet),
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
                    backgroundColor: Color(.violet).opacity(0.15),
                    textColor: Color(.violet),
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
