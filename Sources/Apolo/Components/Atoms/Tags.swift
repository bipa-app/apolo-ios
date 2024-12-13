//
//  Tags.swift
//  Apolo
//
//  Created by Devin on 11/01/24.
//

import SwiftUI

public enum TagStyle {
    case label
    case success
    case warning
    case error
    case custom(backgroundColor: Color, textColor: Color)

    var iconName: String? {
        switch self {
        case .success:
            return "checkmark.circle.fill"
        case .warning:
            return "clock.fill"
        case .error:
            return "exclamationmark.triangle.fill"
        case .label, .custom:
            return nil
        }
    }

    var backgroundColor: Color {
        switch self {
        case .label:
            return .clear
        case .success:
            return .green
        case .warning:
            return .yellow
        case .error:
            return .red
        case let .custom(backgroundColor, _):
            return backgroundColor
        }
    }

    var textColor: Color {
        switch self {
        case .custom(_, let textColor):
            return textColor
        case .label:
            return .primary
        default:
            @Environment(\.colorScheme) var colorScheme
            return colorScheme == .light ? .white : .black
        }
    }
}

public struct Tag: View {
    @Environment(\.colorScheme) private var colorScheme

    private let text: String
    private let style: TagStyle
    private let icon: String?

    public init(
        style: TagStyle = .label,
        text: String,
        icon: String? = nil
    ) {
        self.style = style
        self.text = text
        self.icon = icon
    }

    public var body: some View {
        HStack(spacing: Tokens.Spacing.extraExtraSmall) {
            if let iconToUse = icon ?? style.iconName {
                Image(systemName: iconToUse)
                    .font(.caption)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(style.textColor)
            }

            Text(text)
                .subheadline(weight: .medium)
                .foregroundStyle(style.textColor)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .background(style.backgroundColor)
        .clipShape(.rect(cornerRadius: Tokens.CornerRadius.large))
    }
}

#Preview {
    VStack(alignment: .leading, spacing: Tokens.Spacing.medium) {
        Tag(style: .label, text: "LABEL", icon: "bitcoinsign.circle.fill")
        Tag(style: .success, text: "CONCLUÍDA")
        Tag(style: .warning, text: "PENDENTE")
        Tag(style: .error, text: "FALHADA")
        Tag(style: .custom(backgroundColor: Color(uiColor: .quaternarySystemFill), textColor: .secondary),
            text: "Crédito Virtual",
            icon: "creditcard.fill")
        Tag(style: .custom(backgroundColor: .indigo, textColor: .mint),
            text: "Custom")
    }
    .padding()
}
