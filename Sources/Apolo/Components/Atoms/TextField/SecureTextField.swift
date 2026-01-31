//
//  SecureTextField.swift
//  Apolo
//
//  Created by Apolo on 2025.
//

import SwiftUI

// MARK: - ApoloSecureTextField

public struct ApoloSecureTextField: View {
    @Binding private var text: String
    private let label: String
    private let placeholder: String
    private let helperText: String?
    private let errorMessage: String?
    private let style: ApoloTextFieldStyle
    private let isDisabled: Bool

    @State private var isSecure: Bool = true
    @FocusState private var isFocused: Bool

    public init(
        text: Binding<String>,
        label: String,
        placeholder: String = "",
        helperText: String? = nil,
        errorMessage: String? = nil,
        style: ApoloTextFieldStyle = .outlined,
        isDisabled: Bool = false
    ) {
        self._text = text
        self.label = label
        self.placeholder = placeholder
        self.helperText = helperText
        self.errorMessage = errorMessage
        self.style = style
        self.isDisabled = isDisabled
    }

    private var currentState: TextFieldState {
        if isDisabled { return .disabled }
        if errorMessage != nil { return .error }
        if isFocused { return .focused }
        return .normal
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.extraExtraSmall) {
            // Label
            Text(label)
                .font(.abcGinto(style: .subheadline, weight: .medium))
                .foregroundStyle(currentState.labelColor)

            // Input field
            HStack(spacing: Tokens.Spacing.extraSmall) {
                Image(systemName: "lock.fill")
                    .foregroundStyle(Color(.secondaryLabel))
                    .frame(width: 20)

                Group {
                    if isSecure {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .font(.abcGinto(style: .body, weight: .regular))
                .focused($isFocused)
                .disabled(isDisabled)

                Button {
                    withAnimation(Tokens.Animation.smooth) {
                        isSecure.toggle()
                    }
                } label: {
                    Image(systemName: isSecure ? "eye.fill" : "eye.slash.fill")
                        .foregroundStyle(Color(.secondaryLabel))
                        .frame(width: 20)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, Tokens.Spacing.medium)
            .padding(.vertical, Tokens.Spacing.small)
            .background(style.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.small))
            .overlay(
                RoundedRectangle(cornerRadius: Tokens.CornerRadius.small)
                    .strokeBorder(
                        currentState.borderColor,
                        lineWidth: style.hasBorder ? (isFocused ? 2 : 1) : 0
                    )
            )
            .animation(Tokens.Animation.smooth, value: isFocused)
            .animation(Tokens.Animation.smooth, value: errorMessage)

            // Helper or error text
            if let errorMessage {
                Text(errorMessage)
                    .font(.abcGinto(style: .caption, weight: .regular))
                    .foregroundStyle(Color(.systemRed))
            } else if let helperText {
                Text(helperText)
                    .font(.abcGinto(style: .caption, weight: .regular))
                    .foregroundStyle(Color(.tertiaryLabel))
            }
        }
        .opacity(isDisabled ? 0.6 : 1)
    }
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var password1 = ""
    @Previewable @State var password2 = "secret123"
    @Previewable @State var password3 = ""

    return VStack(spacing: Tokens.Spacing.large) {
        ApoloSecureTextField(
            text: $password1,
            label: "Password",
            placeholder: "Enter your password",
            helperText: "Must be at least 8 characters"
        )

        ApoloSecureTextField(
            text: $password2,
            label: "Confirm Password",
            placeholder: "Re-enter your password"
        )

        ApoloSecureTextField(
            text: $password3,
            label: "PIN",
            placeholder: "Enter PIN",
            errorMessage: "PIN is required",
            style: .filled
        )
    }
    .padding()
}
