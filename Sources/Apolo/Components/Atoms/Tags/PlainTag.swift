//
//  SwiftUIView.swift
//  Apolo
//
//  Created by Eric on 26/12/24.
//

import SwiftUI

// MARK: Plain Tag

struct PlainTag: View {
    let style: Tag.Style
    let title: String

    var body: some View {
        HStack(spacing: Tokens.Spacing.extraExtraSmall) {
            if let icon = style.icon {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(style.textColor)
            }

            Text(title)
                .subheadline()
                .foregroundStyle(style.textColor)
        }
        .padding(.vertical, Tokens.Spacing.extraSmall)
        .padding(.horizontal, Tokens.Spacing.small)
        .background(style.backgroundColor)
        .clipShape(.rect(cornerRadius: Tokens.CornerRadius.large))
    }
}
