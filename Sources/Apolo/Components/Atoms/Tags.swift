//
//  Tags.swift
//  Apolo
//
//  Created by Devin on 11/01/24.
//

import SwiftUI

public enum TagStyle {
    case status
    case label
}

public struct Tag: View {
    private let text: String
    private let style: TagStyle

    public init(text: String, style: TagStyle = .label) {
        self.text = text
        self.style = style
    }

    public var body: some View {
        Text(text)
            .font(.abcGinto(style: .caption1, weight: .medium))
            .padding(.horizontal, Tokens.Spacing.small)
            .padding(.vertical, Tokens.Spacing.extraExtraSmall)
            .background(style == .status ? Color.violet : Color.rose)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.small))
    }
}

#Preview {
    VStack(spacing: Tokens.Spacing.medium) {
        Tag(text: "Active", style: .status)
        Tag(text: "Label", style: .label)
    }
    .padding()
}
