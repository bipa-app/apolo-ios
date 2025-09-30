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
    let size: Tag.Size
    var clearGlass: Bool = true
    
    var body: some View {
        HStack(spacing: Tokens.Spacing.extraExtraSmall) {
            if let icon = style.icon {
                size.applyTypography(
                    Image(systemName: icon)
                        .foregroundStyle(style.textColor)
                )
            }

            size.applyTypography(
                Text(title)
                    .foregroundStyle(style.textColor)
            )

            if let secondaryIcon = style.secondaryIcon {
                size.applyTypography(
                    Image(systemName: secondaryIcon)
                        .foregroundStyle(style.textColor)
                )
            }
        }
        .padding(.vertical, size.verticalPadding)
        .padding(.horizontal, size.horizontalPadding)
        .glassEffectIfAvailable(color: style.backgroundColor, isClear: clearGlass, orElse: { content in
            content
                .background(
                    Capsule()
                    .fill(style.background)
                )
        })
    }
}
