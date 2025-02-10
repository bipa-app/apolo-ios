//
//  Tag.swift
//  Apolo
//
//  Created by Devin on 11/12/24.
//

import SwiftUI

// MARK: Tag

public struct Tag: View {
    public enum Style: Equatable {
        case label(icon: String? = nil)
        case success
        case warning
        case error
        case turbo
        case custom(backgroundColor: Color, textColor: Color, icon: String? = nil)

        var icon: String? {
            switch self {
            case .label(let icon): icon
            case .success: "checkmark.circle.fill"
            case .warning: "clock.fill"
            case .error: "exclamationmark.triangle.fill"
            case .turbo: nil
            case .custom(_, _, let icon): icon
            }
        }

        var textColor: Color {
            switch self {
            case .custom(_, let textColor, _): textColor
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
            case .custom(let backgroundColor, _, _): backgroundColor
            }
        }
    }

    private let style: Style
    private let title: String?

    public init(style: Style = .label()) {
        self.style = style
        self.title = nil
    }

    public init(style: Style = .label(), title: String) {
        self.style = style
        self.title = title
    }

    public var body: some View {
        if case .turbo = style {
            TurboTag()
        } else if let title {
            PlainTag(style: style, title: title)
        }
    }
}

// MARK: Preview

#Preview {
    VStack(alignment: .leading, spacing: Tokens.Spacing.medium) {
        Tag(style: .label(icon: "bitcoinsign.circle.fill"), title: "LABEL")
        Tag(style: .success, title: "CONCLUÍDA")
        Tag(style: .warning, title: "PENDENTE")
        Tag(style: .error, title: "FALHADA")
        Tag(style: .custom(backgroundColor: Color(uiColor: .quaternarySystemFill), textColor: .secondary), title: "Crédito Virtual")
        Tag(style: .turbo)
        Tag(style: .custom(backgroundColor: .indigo, textColor: .mint), title: "Custom")
    }
    .padding()
}
