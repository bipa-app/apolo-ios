//
//  Banner.swift
//  Apolo
//
//  Created by Apolo on 2025.
//

import SwiftUI

// MARK: - BannerStyle

public enum BannerStyle {
    case info
    case success
    case warning
    case error
    case neutral

    var backgroundColor: Color {
        switch self {
        case .info: return Color(.systemBlue)
        case .success: return Color(.systemGreen)
        case .warning: return Color(.systemOrange)
        case .error: return Color(.systemRed)
        case .neutral: return Color(.secondarySystemBackground)
        }
    }

    var foregroundColor: Color {
        switch self {
        case .neutral: return Color(.label)
        default: return .white
        }
    }

    var iconName: String {
        switch self {
        case .info: return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        case .neutral: return "bell.fill"
        }
    }
}

// MARK: - Banner

public struct Banner: View {
    let title: String
    let message: String?
    let style: BannerStyle
    let icon: String?
    let actionLabel: String?
    let action: (() -> Void)?
    let onDismiss: (() -> Void)?

    public init(
        title: String,
        message: String? = nil,
        style: BannerStyle = .info,
        icon: String? = nil,
        actionLabel: String? = nil,
        action: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.style = style
        self.icon = icon
        self.actionLabel = actionLabel
        self.action = action
        self.onDismiss = onDismiss
    }

    public var body: some View {
        HStack(alignment: .top, spacing: Tokens.Spacing.small) {
            Image(systemName: icon ?? style.iconName)
                .font(.system(size: 20))
                .foregroundStyle(style.foregroundColor)

            VStack(alignment: .leading, spacing: Tokens.Spacing.extraExtraSmall) {
                Text(title)
                    .font(.abcGinto(style: .subheadline, weight: .bold))
                    .foregroundStyle(style.foregroundColor)

                if let message {
                    Text(message)
                        .font(.abcGinto(style: .footnote, weight: .regular))
                        .foregroundStyle(style.foregroundColor.opacity(0.9))
                }

                if let actionLabel, let action {
                    Button {
                        action()
                    } label: {
                        Text(actionLabel)
                            .font(.abcGinto(style: .footnote, weight: .bold))
                            .foregroundStyle(style.foregroundColor)
                            .underline()
                    }
                    .padding(.top, Tokens.Spacing.extraExtraSmall)
                }
            }

            Spacer(minLength: 0)

            if let onDismiss {
                Button {
                    onDismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(style.foregroundColor.opacity(0.8))
                }
            }
        }
        .padding(Tokens.Spacing.medium)
        .background(style.backgroundColor)
    }
}

// MARK: - BannerModifier

public struct BannerModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String?
    let style: BannerStyle
    let position: BannerPosition

    public enum BannerPosition {
        case top
        case bottom
    }

    public func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: position == .top ? .top : .bottom) {
                if isPresented {
                    Banner(
                        title: title,
                        message: message,
                        style: style,
                        onDismiss: {
                            withAnimation(Tokens.Animation.smooth) {
                                isPresented = false
                            }
                        }
                    )
                    .transition(.move(edge: position == .top ? .top : .bottom).combined(with: .opacity))
                }
            }
            .animation(Tokens.Animation.spring, value: isPresented)
    }
}

public extension View {
    func banner(
        isPresented: Binding<Bool>,
        title: String,
        message: String? = nil,
        style: BannerStyle = .info,
        position: BannerModifier.BannerPosition = .top
    ) -> some View {
        modifier(
            BannerModifier(
                isPresented: isPresented,
                title: title,
                message: message,
                style: style,
                position: position
            )
        )
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 0) {
        Banner(
            title: "New Update Available",
            message: "Version 2.0 is now available with new features",
            style: .info,
            actionLabel: "Update Now",
            action: { print("Update") },
            onDismiss: { print("Dismiss") }
        )

        Banner(
            title: "Transaction Confirmed",
            message: "Your Bitcoin has been sent successfully",
            style: .success,
            onDismiss: { print("Dismiss") }
        )

        Banner(
            title: "Low Balance",
            message: "Your balance is running low",
            style: .warning
        )

        Banner(
            title: "Connection Lost",
            message: "Please check your internet connection",
            style: .error,
            actionLabel: "Retry",
            action: { print("Retry") }
        )

        Banner(
            title: "Scheduled Maintenance",
            message: "System will be down for maintenance tonight",
            style: .neutral,
            onDismiss: { print("Dismiss") }
        )
    }
}

@available(iOS 17.0, *)
#Preview("Banner Modifier") {
    @Previewable @State var showBanner = true

    VStack {
        Text("Content here")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .banner(
        isPresented: $showBanner,
        title: "Offline Mode",
        message: "You are currently offline",
        style: .warning
    )
}
