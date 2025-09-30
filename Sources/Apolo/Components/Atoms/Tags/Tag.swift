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

    public enum Style {
        case label(icon: String? = nil)
        case success
        case warning
        case error
        case turbo
        case premium
        case custom(
            shapeStyle: (any ShapeStyle)? = nil,
            backgroundColor: Color = .clear,
            textColor: Color = .primary,
            icon: String? = nil,
            secondaryIcon: String? = nil
        )
        
        var icon: String? {
            switch self {
            case let .label(icon): icon
            case .success: "checkmark.circle.fill"
            case .warning: "clock.fill"
            case .error: "exclamationmark.triangle.fill"
            case .turbo, .premium: nil
            case let .custom(_, _, _, icon, _): icon
            }
        }

        var secondaryIcon: String? {
            switch self {
            case .label, .success, .warning, .error, .turbo, .premium: nil
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
            case .label, .turbo, .premium:
                return .init(Color.clear)
            case .success:
                return .init(Tokens.Color.green.color)
            case .warning:
                return .init(Tokens.Color.yellow.color)
            case .error:
                return .init(Tokens.Color.red.color)
            case let .custom(shapeStyle, backgroundColor, _, _, _):
                if let shapeStyle {
                    return .init(shapeStyle)
                }
                return .init(backgroundColor)
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .label, .turbo, .premium:
                return Color.clear
            case .success:
                return Tokens.Color.green.color
            case .warning:
                return Tokens.Color.yellow.color
            case .error:
                return Tokens.Color.red.color
            case let .custom(_, backgroundColor, _, _, _):
                return backgroundColor
            }
        }
    }

    // MARK: - Properties

    private let style: Style
    private let title: String?
    private let size: Size
    private let clearGlass: Bool

    // MARK: - Initialization

    public init(style: Style = .label(), size: Size = .regular, clearGlass: Bool = true) {
        self.style = style
        title = nil
        self.size = size
        self.clearGlass = clearGlass
    }

    public init(style: Style = .label(), title: String, size: Size = .regular, clearGlass: Bool = true) {
        self.style = style
        self.title = title
        self.size = size
        self.clearGlass = clearGlass
    }

    // MARK: - Body

    public var body: some View {
        if case .premium = style {
            PremiumTag()
        }
        if case .turbo = style {
            TurboTag()
        } else if let title {
            PlainTag(style: style, title: title, size: size, clearGlass: clearGlass)
        }
    }
}

// MARK: - Equatable

extension Tag.Style: Equatable {
    
    // Manual implementation required because ShapeStyle (used in `.custom`) is not Equatable.
    // We compare only equatable associated values and ignore shapeStyle.
    public static func == (lhs: Tag.Style, rhs: Tag.Style) -> Bool {
        switch (lhs, rhs) {
        case let (.label(a), .label(b)):
            return a == b
        case (.success, .success),
             (.warning, .warning),
             (.error, .error),
             (.turbo, .turbo):
            return true
        case let (.custom(_, bg1, txt1, i1, s1), .custom(_, bg2, txt2, i2, s2)):
            return bg1 == bg2 && txt1 == txt2 && i1 == i2 && s1 == s2
        default:
            return false
        }
    }
}

// MARK: - Preview

#Preview {
    ScrollView(.vertical) {
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
                Tag(style: .premium)
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
                    size: .regular,
                    clearGlass: false
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
                    size: .small,
                    clearGlass: false
                )
                
                Tag(
                    style: .custom(
                        shapeStyle: .quaternary,
                        textColor: .white
                    ),
                    title: "Conheça agora"
                )
                .multilineTextAlignment(.center)
                
                Tag(
                    style: .custom(
                        backgroundColor: Tokens.Color.green.color.opacity(0.15),
                        textColor: Tokens.Color.green.color
                    ),
                    title: "Recomendado",
                    size: .small
                )
            }
        }
        .padding()
    }
}
