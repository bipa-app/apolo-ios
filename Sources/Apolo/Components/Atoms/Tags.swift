//
//  Tags.swift
//  Apolo
//
//  Created by Devin on 11/12/24.
//

import SwiftUI

// MARK: Tag

public struct Tag: View {
    
    // MARK: Public
    
    public init(
        style: Tag.Style = .label(),
        title: String
    ) {
        self.style = style
        self.title = title
    }
    
    public var body: some View {
        HStack(spacing: Tokens.Spacing.extraExtraSmall) {
            if let icon {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(textColor)
            }
            
            Text(title)
                .subheadline()
                .foregroundStyle(textColor)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .background(backgroundColor)
        .clipShape(.rect(cornerRadius: Tokens.CornerRadius.large))
    }
    
    // MARK: Private

    private let style: Tag.Style
    private let title: String
    
    private var backgroundColor: Color {
        switch style {
        case .label: .clear
        case .success: .green
        case .warning: .yellow
        case .error: .red
        case .custom(let backgroundColor, _, _): backgroundColor
        }
    }
    
    private var textColor: Color {
        switch style {
        case .custom(_, let textColor, _): textColor
        case .label: .primary
        default: Color(uiColor: .systemBackground)
        }
    }
    
    private var icon: String? {
        switch style {
        case .label(let icon): icon
        case .success: "checkmark.circle.fill"
        case .warning: "clock.fill"
        case .error: "exclamationmark.triangle.fill"
        case .custom(_, _, let icon): icon
        }
    }
}

// MARK: Tag.Style

public extension Tag {
    enum Style {
        case label(icon: String? = nil)
        case success
        case warning
        case error
        case custom(backgroundColor: Color, textColor: Color, icon: String? = nil)
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
        Tag(style: .custom(backgroundColor: .indigo, textColor: .mint), title: "Custom")
    }
    .padding()
}
