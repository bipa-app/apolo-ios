//
//  InlineAlert.swift
//  Apolo
//
//  Created by Apolo on 2025.
//

import SwiftUI

// MARK: - InlineAlertStyle

public enum InlineAlertStyle {
    case info
    case success
    case warning
    case error
    case tip

    var iconName: String {
        switch self {
        case .info: return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        case .tip: return "lightbulb.fill"
        }
    }

    var accentColor: Color {
        switch self {
        case .info: return Color(.systemBlue)
        case .success: return Color(.systemGreen)
        case .warning: return Color(.systemOrange)
        case .error: return Color(.systemRed)
        case .tip: return Color(.systemYellow)
        }
    }

    var backgroundColor: Color {
        switch self {
        case .info: return Color(.systemBlue).opacity(0.08)
        case .success: return Color(.systemGreen).opacity(0.08)
        case .warning: return Color(.systemOrange).opacity(0.08)
        case .error: return Color(.systemRed).opacity(0.08)
        case .tip: return Color(.systemYellow).opacity(0.08)
        }
    }
}

// MARK: - InlineAlert

public struct InlineAlert: View {
    let title: String?
    let message: String
    let style: InlineAlertStyle
    let icon: String?
    let actionLabel: String?
    let action: (() -> Void)?

    public init(
        title: String? = nil,
        message: String,
        style: InlineAlertStyle = .info,
        icon: String? = nil,
        actionLabel: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.style = style
        self.icon = icon
        self.actionLabel = actionLabel
        self.action = action
    }

    public var body: some View {
        HStack(alignment: .top, spacing: Tokens.Spacing.small) {
            Image(systemName: icon ?? style.iconName)
                .foregroundStyle(style.accentColor)
                .font(.system(size: 18))

            VStack(alignment: .leading, spacing: Tokens.Spacing.extraExtraSmall) {
                if let title {
                    Text(title)
                        .font(.abcGinto(style: .subheadline, weight: .bold))
                        .foregroundStyle(Color(.label))
                }

                Text(message)
                    .font(.abcGinto(style: .footnote, weight: .regular))
                    .foregroundStyle(Color(.secondaryLabel))

                if let actionLabel, let action {
                    Button {
                        action()
                    } label: {
                        Text(actionLabel)
                            .font(.abcGinto(style: .footnote, weight: .bold))
                            .foregroundStyle(style.accentColor)
                    }
                    .padding(.top, Tokens.Spacing.extraExtraSmall)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(Tokens.Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: Tokens.CornerRadius.medium)
                .fill(style.backgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Tokens.CornerRadius.medium)
                .strokeBorder(style.accentColor.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(spacing: Tokens.Spacing.medium) {
            InlineAlert(
                title: "Information",
                message: "Your transaction is being processed. This may take a few minutes.",
                style: .info
            )

            InlineAlert(
                message: "Payment completed successfully!",
                style: .success
            )

            InlineAlert(
                title: "Warning",
                message: "Your session will expire in 5 minutes. Please save your work.",
                style: .warning,
                actionLabel: "Extend Session"
            ) {
                print("Extend")
            }

            InlineAlert(
                title: "Error",
                message: "Failed to process payment. Please check your balance and try again.",
                style: .error,
                actionLabel: "Try Again"
            ) {
                print("Retry")
            }

            InlineAlert(
                title: "Pro Tip",
                message: "You can use Face ID to quickly approve transactions in settings.",
                style: .tip,
                icon: "faceid"
            )
        }
        .padding()
    }
}
