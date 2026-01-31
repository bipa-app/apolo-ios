//
//  Toast.swift
//  Apolo
//
//  Created by Apolo on 2025.
//

import SwiftUI

// MARK: - ToastStyle

public enum ToastStyle {
    case info
    case success
    case warning
    case error

    var iconName: String {
        switch self {
        case .info: return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        }
    }

    var iconColor: Color {
        switch self {
        case .info: return Color(.systemBlue)
        case .success: return Color(.systemGreen)
        case .warning: return Color(.systemOrange)
        case .error: return Color(.systemRed)
        }
    }

    var backgroundColor: Color {
        switch self {
        case .info: return Color(.systemBlue).opacity(0.1)
        case .success: return Color(.systemGreen).opacity(0.1)
        case .warning: return Color(.systemOrange).opacity(0.1)
        case .error: return Color(.systemRed).opacity(0.1)
        }
    }
}

// MARK: - Toast

public struct Toast: View {
    let message: String
    let style: ToastStyle
    let action: (() -> Void)?
    let actionLabel: String?

    public init(
        message: String,
        style: ToastStyle = .info,
        actionLabel: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.message = message
        self.style = style
        self.actionLabel = actionLabel
        self.action = action
    }

    public var body: some View {
        HStack(spacing: Tokens.Spacing.small) {
            Image(systemName: style.iconName)
                .foregroundStyle(style.iconColor)
                .font(.system(size: 20))

            Text(message)
                .font(.abcGinto(style: .subheadline, weight: .medium))
                .foregroundStyle(Color(.label))
                .lineLimit(2)

            Spacer(minLength: 0)

            if let actionLabel, let action {
                Button(actionLabel) {
                    action()
                }
                .font(.abcGinto(style: .subheadline, weight: .bold))
                .foregroundStyle(style.iconColor)
            }
        }
        .padding(.horizontal, Tokens.Spacing.medium)
        .padding(.vertical, Tokens.Spacing.small)
        .background(
            RoundedRectangle(cornerRadius: Tokens.CornerRadius.medium)
                .fill(Color(.secondarySystemBackground))
        )
        .shadow(.medium)
    }
}

// MARK: - ToastModifier

public struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let style: ToastStyle
    let duration: TimeInterval
    let position: ToastPosition

    public enum ToastPosition {
        case top
        case bottom
    }

    public init(
        isPresented: Binding<Bool>,
        message: String,
        style: ToastStyle,
        duration: TimeInterval,
        position: ToastPosition
    ) {
        self._isPresented = isPresented
        self.message = message
        self.style = style
        self.duration = duration
        self.position = position
    }

    public func body(content: Content) -> some View {
        content
            .overlay(alignment: position == .top ? .top : .bottom) {
                if isPresented {
                    Toast(message: message, style: style)
                        .padding(.horizontal, Tokens.Spacing.medium)
                        .padding(position == .top ? .top : .bottom, Tokens.Spacing.large)
                        .transition(.move(edge: position == .top ? .top : .bottom).combined(with: .opacity))
                        .zIndex(Tokens.ZIndex.toast)
                        .onAppear {
                            if duration > 0 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                    withAnimation(Tokens.Animation.smooth) {
                                        isPresented = false
                                    }
                                }
                            }
                        }
                }
            }
            .animation(Tokens.Animation.spring, value: isPresented)
    }
}

public extension View {
    func toast(
        isPresented: Binding<Bool>,
        message: String,
        style: ToastStyle = .info,
        duration: TimeInterval = 3,
        position: ToastModifier.ToastPosition = .top
    ) -> some View {
        modifier(
            ToastModifier(
                isPresented: isPresented,
                message: message,
                style: style,
                duration: duration,
                position: position
            )
        )
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: Tokens.Spacing.medium) {
        Toast(message: "This is an info message", style: .info)
        Toast(message: "Operation completed successfully!", style: .success)
        Toast(message: "Please check your connection", style: .warning)
        Toast(message: "Something went wrong", style: .error, actionLabel: "Retry") {
            print("Retry tapped")
        }
    }
    .padding()
}

@available(iOS 17.0, *)
#Preview("Toast Modifier") {
    @Previewable @State var showToast = false

    VStack {
        Button("Show Toast") {
            withAnimation {
                showToast = true
            }
        }
        .borderedProminentStyle()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .toast(isPresented: $showToast, message: "Transaction sent!", style: .success)
}
