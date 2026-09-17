//
//  SwiftUIView.swift
//  Apolo
//
//  Created by Eric on 26/12/24.
//

import SwiftUI

// MARK: Plain Tag

struct PlainTag: View {
    // Both Reduce Transparency and Increase Contrast make the system swap Liquid Glass for an opaque
    // fill, and for `.clear` glass that fill is dark even in Light mode — a tinted tag came out
    // dark-on-dark (the green P&L tag read as dark green text on a dark green pill). Either setting
    // means "prefer legibility over the material", so drop the glass and use the flat capsule.
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast

    private var prefersFlatBackground: Bool {
        reduceTransparency || colorSchemeContrast == .increased
    }

    let style: Tag.Style
    let title: String
    let size: Tag.Size
    var clearGlass: Bool = true
    var glassInteractive: Bool = true
    
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
        .overlay {
            if let borderStyle = style.borderStyle {
                Capsule()
                    .strokeBorder(borderStyle, lineWidth: 2)
            }
        }
        .modifier(
            TagBackground(
                style: style,
                clearGlass: clearGlass,
                glassInteractive: glassInteractive,
                prefersFlatBackground: prefersFlatBackground
            )
        )
    }
}

// MARK: - Tag Background

private struct TagBackground: ViewModifier {
    let style: Tag.Style
    let clearGlass: Bool
    let glassInteractive: Bool
    let prefersFlatBackground: Bool

    @ViewBuilder
    func body(content: Content) -> some View {
        if prefersFlatBackground {
            content
                .background(
                    Capsule()
                    .fill(style.background)
                )
        } else {
            content
                .glassEffectIfAvailable(color: style.backgroundColor, isClear: clearGlass, interactive: glassInteractive, orElse: { content in
                    content
                        .background(
                            Capsule()
                            .fill(style.background)
                        )
                })
        }
    }
}
