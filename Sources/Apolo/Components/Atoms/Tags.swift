//
//  Tags.swift
//  Apolo
//
//  Created by Devin on 11/01/24.
//

import SwiftUI

public enum TagStyle {
    case status(backgroundColor: Color, icon: String? = nil)
    case label(icon: String? = nil)

    var iconName: String? {
        switch self {
        case let .status(_, icon), let .label(icon):
            return icon
        }
    }
}

public struct Tag: View {
    private let text: String
    private let style: TagStyle
    private let textColor: Color?

    public init(
        text: String,
        style: TagStyle = .label(),
        textColor: Color? = nil
    ) {
        self.text = text
        self.style = style
        self.textColor = textColor
    }

    private var resolvedBackgroundColor: Color {
        switch style {
        case let .status(backgroundColor, _):
            return backgroundColor
        case .label:
            return .clear
        }
    }

    public var body: some View {
        HStack(spacing: Tokens.Spacing.extraExtraSmall) {
            if let iconName = style.iconName {
                Image(systemName: iconName)
                    .font(.caption)
                    .foregroundStyle(textColor ?? .primary)
            }
            Text(text)
                .caption1(weight: .medium)
                .foregroundStyle(textColor ?? .primary)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .background(resolvedBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.large))
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 8) {
        Tag(text: "LABEL", style: .label(icon: "bitcoinsign.circle.fill"))
        Tag(text: "CONCLUÍDA", style: .status(backgroundColor: .green, icon: "checkmark.circle.fill"))
        Tag(text: "PENDENTE", style: .status(backgroundColor: .yellow, icon: "clock.fill"))
        Tag(text: "FALHADA", style: .status(backgroundColor: .red, icon: "exclamationmark.triangle.fill"))
        Tag(text: "Custom Text Color",
            style: .label(icon: "star.fill"),
            textColor: .pink)
    }
    .padding()
}
