//
//  Tags.swift
//  Apolo
//
//  Created by Devin on 11/12/24.
//

import SwiftUI

// MARK: Tag

public enum TagStyle {
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

// MARK: - Tag Content

private struct TagContent: View {
    let style: TagStyle
    let title: String

    var body: some View {
        switch style {
        case .turbo:
            turboContent
        default:
            defaultContent
        }
    }

    private var turboContent: some View {
        HStack(spacing: Tokens.Spacing.extraExtraSmall) {
            Text("Bipa")
                .subheadline()
            Text("Turbo")
                .subheadline()
                .fontWeight(.medium)
                .italic()
        }
        .foregroundStyle(.white)
    }

    private var defaultContent: some View {
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
    }
}

// MARK: - Tag Background

struct FlowEffect: GeometryEffect {
    var phase: CGFloat

    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        let transform = CGAffineTransform(
            a: 1 + sin(phase) * 0.3,
            b: cos(phase * 2) * 0.1,
            c: sin(phase * 2) * 0.1,
            d: 1 + cos(phase) * 0.2,
            tx: sin(phase) * 5,
            ty: cos(phase) * 5
        )
        return ProjectionTransform(transform)
    }
}

private struct TagBackground: View {
    let style: TagStyle
    @State private var phase: CGFloat = 0

    var body: some View {
        switch style {
        case .turbo:
            Rectangle()
                .fill(RadialGradient(gradient: Gradient(colors: [
                    Color(red: 255/255, green: 187/255, blue: 0/255),
                    Color(red: 255/255, green: 109/255, blue: 0/255),
                    Color(red: 217/255, green: 93/255, blue: 213/255),
                    Color(red: 57/255, green: 121/255, blue: 255/255)
                ]), center: .center, startRadius: 40, endRadius: 4))
                .modifier(FlowEffect(phase: phase))
                .scaleEffect(4)
                .onAppear {
                    withAnimation(.linear(duration: 8).repeatForever(autoreverses: true)) {
                        phase = .pi * 2
                    }
                }
        default:
            style.backgroundColor
        }
    }
}

// MARK: - Tag View

public struct Tag: View {
    private let style: TagStyle
    private let title: String

    public init(
        style: TagStyle = .label(),
        title: String
    ) {
        self.style = style
        self.title = title
    }

    public var body: some View {
        TagContent(style: style, title: title)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(TagBackground(style: style))
            .clipShape(.rect(cornerRadius: Tokens.CornerRadius.large))
    }
}

// MARK: - Preview

#Preview {
    VStack(alignment: .leading, spacing: Tokens.Spacing.medium) {
        Tag(style: .label(icon: "bitcoinsign.circle.fill"), title: "LABEL")
        Tag(style: .success, title: "CONCLUÍDA")
        Tag(style: .warning, title: "PENDENTE")
        Tag(style: .error, title: "FALHADA")
        Tag(style: .custom(backgroundColor: Color(uiColor: .quaternarySystemFill), textColor: .secondary), title: "Crédito Virtual")
        Tag(style: .turbo, title: "")
        Tag(style: .custom(backgroundColor: .indigo, textColor: .mint), title: "Custom")
    }
    .padding()
}
