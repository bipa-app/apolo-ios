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
        case .status(_, let icon), .label(let icon):
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
        case .status(let backgroundColor, _):
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
                    .frame(width: 24, height: 24)
                    .foregroundStyle(textColor ?? .primary)
            }
            Text(text)
                .caption1(weight: .medium)
                .foregroundStyle(textColor ?? .primary)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .background(resolvedBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.small))
    }
}

#Preview {
    VStack(spacing: 8) {
        Tag(text: "Status Purple", style: .status(backgroundColor: .violet))
        Tag(text: "Status Rose", style: .status(backgroundColor: .rose))
        Tag(text: "Status with Icon",
            style: .status(backgroundColor: .violet, icon: "checkmark"))
        Tag(text: "Label Default", style: .label())
        Tag(text: "Label with Icon", style: .label(icon: "bitcoinsign"))
        Tag(text: "Custom Text Color",
            style: .label(icon: "star.fill"),
            textColor: .rose)
    }
    .padding()
}
