//
//  CopyButton.swift
//  Apolo
//
//  Created by Ramon Santos on 26/02/25.
//

import SwiftUI

// MARK: CopyButton

public struct CopyButton: View {
    public init(
        value: String,
        color: Color = .primary,
        successColor: Color = .green,
        title: String? = nil,
        titlePosition: TitlePosition = .right,
        titleFont: Font? = .body(),
        maxWidth: CGFloat? = nil,
        alignment: Alignment = .center,
        onCopied: ((String) -> Void)? = nil
    ) {
        self.value = value
        self.color = color
        self.successColor = successColor
        self.title = title
        self.titlePosition = titlePosition
        self.titleFont = titleFont
        self.maxWidth = maxWidth
        self.alignment = alignment
        self.onCopied = onCopied
    }

    private let value: String
    private let color: Color
    private let successColor: Color
    private let title: String?
    private let titlePosition: TitlePosition
    private let titleFont: Font?
    private let maxWidth: CGFloat?
    private let alignment: Alignment
    private let onCopied: ((String) -> Void)?
    @State private var copied = false
    @ScaledMetric private var size: CGFloat = 24

    public var body: some View {
        Button(
            action: {
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                UIPasteboard.general.string = value
                onCopied?(value)
                
                withAnimation { copied = true }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation { copied = false }
                }
            },
            label: {
                HStack {
                    if let title, titlePosition == .left {
                        label(title)
                            .foregroundStyle(color)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    if #available(iOS 18.0, *) {
                        image
                            .contentTransition(.symbolEffect(.replace.magic(fallback: .downUp.byLayer), options: .nonRepeating))
                    } else {
                        image
                            .transition(.opacity)
                    }
                    
                    if let title, titlePosition == .right {
                        label(title)
                            .foregroundStyle(color)
                            .multilineTextAlignment(.leading)
                    }
                }
                .frame(maxWidth: maxWidth, alignment: alignment)
            }
        )
        .accessibilityLabel("Botão de copiar")
        .accessibilityHint("Toque para copiar o texto")
        .accessibilityValue(value)
    }
    
    private var image: some View {
        Image(systemName: copied ? "checkmark" : "square.on.square")
            .foregroundStyle(copied ? successColor : color)
            .frame(width: size, height: size)
            .contentShape(.rect)
    }
    
    private func label(_ title: String) -> some View {
        Text(title)
            .font(titleFont)
    }
}

public extension CopyButton {
    enum TitlePosition {
        case left
        case right
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: Tokens.Spacing.medium) {
        CopyButton(value: "example1") { value in
            print("Copied value is: \(value)")
        }

        CopyButton(value: "example2", successColor: Color(.violet)) {
            value in
            print("Copied value is: \(value)")
        }
        
        CopyButton(value: "example3", color: .blue, successColor: .orange) {
            value in
            print("Copied value is: \(value)")
        }
        
        CopyButton(value: "example4", color: .orange, title: "with title") {
            value in
            print("Copied value is: \(value)")
        }
        
        CopyButton(value: "example5", color: .green, title: "Custom Font Title", titleFont: .largeTitle) {
            value in
            print("Copied value is: \(value)")
        }
        
        CopyButton(value: "example6", title: "Title in Left", titlePosition: .left) {
            value in
            print("Copied value is: \(value)")
        }
        
        CopyButton(value: "example7", title: "With Button Modifiers") {
            value in
            print("Copied value is: \(value)")
        }
        .borderedProminentStyle()
        
        CopyButton(value: "example8", title: "With Button Modifiers") {
            value in
            print("Copied value is: \(value)")
        }
        .strokedStyle()
    }
}
