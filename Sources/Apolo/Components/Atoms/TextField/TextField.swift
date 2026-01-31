//
//  TextField.swift
//  Apolo
//
//  Created by Apolo on 2025.
//

import SwiftUI

// MARK: - TextFieldStyle

public enum ApoloTextFieldStyle {
    case outlined
    case filled

    var backgroundColor: Color {
        switch self {
        case .outlined: return .clear
        case .filled: return Color(.tertiarySystemFill)
        }
    }

    var hasBorder: Bool {
        switch self {
        case .outlined: return true
        case .filled: return false
        }
    }
}

// MARK: - TextFieldState

public enum TextFieldState {
    case normal
    case focused
    case error
    case success
    case disabled

    var borderColor: Color {
        switch self {
        case .normal: return Color(.separator)
        case .focused: return Tokens.Color.violet.color
        case .error: return Color(.systemRed)
        case .success: return Color(.systemGreen)
        case .disabled: return Color(.separator).opacity(0.5)
        }
    }

    var labelColor: Color {
        switch self {
        case .error: return Color(.systemRed)
        case .success: return Color(.systemGreen)
        case .disabled: return Color(.tertiaryLabel)
        default: return Color(.secondaryLabel)
        }
    }
}

// MARK: - ApoloTextField

public struct ApoloTextField: View {
    @Binding private var text: String
    private let label: String
    private let placeholder: String
    private let helperText: String?
    private let errorMessage: String?
    private let leadingIcon: String?
    private let trailingIcon: String?
    private let style: ApoloTextFieldStyle
    private let maxLength: Int?
    private let isDisabled: Bool
    private let onTrailingIconTap: (() -> Void)?

    @FocusState private var isFocused: Bool

    public init(
        text: Binding<String>,
        label: String,
        placeholder: String = "",
        helperText: String? = nil,
        errorMessage: String? = nil,
        leadingIcon: String? = nil,
        trailingIcon: String? = nil,
        style: ApoloTextFieldStyle = .outlined,
        maxLength: Int? = nil,
        isDisabled: Bool = false,
        onTrailingIconTap: (() -> Void)? = nil
    ) {
        self._text = text
        self.label = label
        self.placeholder = placeholder
        self.helperText = helperText
        self.errorMessage = errorMessage
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.style = style
        self.maxLength = maxLength
        self.isDisabled = isDisabled
        self.onTrailingIconTap = onTrailingIconTap
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
                if let leadingIcon {
                    Image(systemName: leadingIcon)
                        .foregroundStyle(Color(.secondaryLabel))
                        .frame(width: 20)
                }

                TextField(placeholder, text: $text)
                    .font(.abcGinto(style: .body, weight: .regular))
                    .focused($isFocused)
                    .disabled(isDisabled)
                    .onChange(of: text) { newValue in
                        if let maxLength, newValue.count > maxLength {
                            text = String(newValue.prefix(maxLength))
                        }
                    }

                if let trailingIcon {
                    Button {
                        onTrailingIconTap?()
                    } label: {
                        Image(systemName: trailingIcon)
                            .foregroundStyle(Color(.secondaryLabel))
                            .frame(width: 20)
                    }
                    .buttonStyle(.plain)
                }
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
            HStack {
                if let errorMessage {
                    Text(errorMessage)
                        .font(.abcGinto(style: .caption, weight: .regular))
                        .foregroundStyle(Color(.systemRed))
                } else if let helperText {
                    Text(helperText)
                        .font(.abcGinto(style: .caption, weight: .regular))
                        .foregroundStyle(Color(.tertiaryLabel))
                }

                Spacer()

                if let maxLength {
                    Text("\(text.count)/\(maxLength)")
                        .font(.abcGinto(style: .caption, weight: .regular))
                        .foregroundStyle(Color(.tertiaryLabel))
                }
            }
        }
        .opacity(isDisabled ? 0.6 : 1)
    }
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var text1 = ""
    @Previewable @State var text2 = "Hello"
    @Previewable @State var text3 = ""
    @Previewable @State var text4 = ""

    return ScrollView {
        VStack(spacing: Tokens.Spacing.large) {
            ApoloTextField(
                text: $text1,
                label: "Email",
                placeholder: "Enter your email",
                helperText: "We'll never share your email"
            )

            ApoloTextField(
                text: $text2,
                label: "Username",
                placeholder: "Choose a username",
                leadingIcon: "person.fill",
                maxLength: 20
            )

            ApoloTextField(
                text: $text3,
                label: "Password",
                placeholder: "Enter password",
                errorMessage: "Password must be at least 8 characters",
                leadingIcon: "lock.fill",
                trailingIcon: "eye.fill"
            )

            ApoloTextField(
                text: $text4,
                label: "Disabled Field",
                placeholder: "Cannot edit",
                style: .filled,
                isDisabled: true
            )

            ApoloTextField(
                text: $text1,
                label: "Filled Style",
                placeholder: "Enter text",
                leadingIcon: "magnifyingglass",
                style: .filled
            )
        }
        .padding()
    }
}
