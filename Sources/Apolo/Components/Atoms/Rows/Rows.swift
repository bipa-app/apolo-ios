//
//  Rows.swift
//  Apolo
//
//  Created by Apolo on 2025.
//

import SwiftUI

// MARK: - ListRow

public struct ListRow<Leading: View, Trailing: View>: View {
    let title: String
    let subtitle: String?
    let leading: Leading
    let trailing: Trailing
    let action: (() -> Void)?

    public init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder leading: () -> Leading = { EmptyView() },
        @ViewBuilder trailing: () -> Trailing = { EmptyView() },
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.leading = leading()
        self.trailing = trailing()
        self.action = action
    }

    public var body: some View {
        Button {
            action?()
        } label: {
            HStack(spacing: Tokens.Spacing.small) {
                leading

                VStack(alignment: .leading, spacing: Tokens.Spacing.extraExtraSmall) {
                    Text(title)
                        .font(.abcGinto(style: .body, weight: .regular))
                        .foregroundStyle(Color(.label))

                    if let subtitle {
                        Text(subtitle)
                            .font(.abcGinto(style: .footnote, weight: .regular))
                            .foregroundStyle(Color(.secondaryLabel))
                    }
                }

                Spacer()

                trailing

                if action != nil {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color(.tertiaryLabel))
                }
            }
            .padding(.vertical, Tokens.Spacing.small)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(action == nil)
    }
}

// MARK: - SettingsRow

public struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String?
    let showChevron: Bool
    let action: (() -> Void)?

    public init(
        icon: String,
        iconColor: Color = Color(.systemBlue),
        title: String,
        value: String? = nil,
        showChevron: Bool = true,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.value = value
        self.showChevron = showChevron
        self.action = action
    }

    public var body: some View {
        Button {
            action?()
        } label: {
            HStack(spacing: Tokens.Spacing.small) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 28)
                    .background(iconColor)
                    .clipShape(RoundedRectangle(cornerRadius: 6))

                // Title
                Text(title)
                    .font(.abcGinto(style: .body, weight: .regular))
                    .foregroundStyle(Color(.label))

                Spacer()

                // Value
                if let value {
                    Text(value)
                        .font(.abcGinto(style: .body, weight: .regular))
                        .foregroundStyle(Color(.secondaryLabel))
                }

                // Chevron
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color(.tertiaryLabel))
                }
            }
            .padding(.vertical, Tokens.Spacing.extraSmall)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(action == nil)
    }
}

// MARK: - ToggleRow

public struct ToggleRow: View {
    let icon: String?
    let iconColor: Color
    let title: String
    let subtitle: String?
    @Binding var isOn: Bool

    public init(
        icon: String? = nil,
        iconColor: Color = Color(.systemBlue),
        title: String,
        subtitle: String? = nil,
        isOn: Binding<Bool>
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.subtitle = subtitle
        self._isOn = isOn
    }

    public var body: some View {
        Toggle(isOn: $isOn) {
            HStack(spacing: Tokens.Spacing.small) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundStyle(.white)
                        .frame(width: 28, height: 28)
                        .background(iconColor)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }

                VStack(alignment: .leading, spacing: Tokens.Spacing.extraExtraSmall) {
                    Text(title)
                        .font(.abcGinto(style: .body, weight: .regular))
                        .foregroundStyle(Color(.label))

                    if let subtitle {
                        Text(subtitle)
                            .font(.abcGinto(style: .footnote, weight: .regular))
                            .foregroundStyle(Color(.secondaryLabel))
                    }
                }
            }
        }
        .tint(Tokens.Color.violet.color)
        .padding(.vertical, Tokens.Spacing.extraSmall)
    }
}

// MARK: - InfoRow

public struct InfoRow: View {
    let label: String
    let value: String
    let valueColor: Color
    let isCopyable: Bool

    @State private var copied = false

    public init(
        label: String,
        value: String,
        valueColor: Color = Color(.label),
        isCopyable: Bool = false
    ) {
        self.label = label
        self.value = value
        self.valueColor = valueColor
        self.isCopyable = isCopyable
    }

    public var body: some View {
        HStack {
            Text(label)
                .font(.abcGinto(style: .body, weight: .regular))
                .foregroundStyle(Color(.secondaryLabel))

            Spacer()

            if isCopyable {
                Button {
                    UIPasteboard.general.string = value
                    withAnimation {
                        copied = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            copied = false
                        }
                    }
                } label: {
                    HStack(spacing: Tokens.Spacing.extraExtraSmall) {
                        Text(value)
                            .font(.abcGinto(style: .body, weight: .medium))
                            .foregroundStyle(valueColor)
                            .lineLimit(1)

                        Image(systemName: copied ? "checkmark" : "doc.on.doc")
                            .font(.system(size: 12))
                            .foregroundStyle(copied ? .green : Color(.tertiaryLabel))
                    }
                }
                .buttonStyle(.plain)
            } else {
                Text(value)
                    .font(.abcGinto(style: .body, weight: .medium))
                    .foregroundStyle(valueColor)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, Tokens.Spacing.extraSmall)
    }
}

// MARK: - ActionRow

public struct ActionRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String?
    let isDestructive: Bool
    let action: () -> Void

    public init(
        icon: String,
        iconColor: Color = Color(.label),
        title: String,
        subtitle: String? = nil,
        isDestructive: Bool = false,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.iconColor = isDestructive ? Color(.systemRed) : iconColor
        self.title = title
        self.subtitle = subtitle
        self.isDestructive = isDestructive
        self.action = action
    }

    public var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: Tokens.Spacing.small) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(iconColor)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: Tokens.Spacing.extraExtraSmall) {
                    Text(title)
                        .font(.abcGinto(style: .body, weight: .regular))
                        .foregroundStyle(isDestructive ? Color(.systemRed) : Color(.label))

                    if let subtitle {
                        Text(subtitle)
                            .font(.abcGinto(style: .footnote, weight: .regular))
                            .foregroundStyle(Color(.secondaryLabel))
                    }
                }

                Spacer()
            }
            .padding(.vertical, Tokens.Spacing.small)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .modifier(HapticFeedbackModifier(style: .light))
    }
}

// MARK: - Preview

#Preview("List Rows") {
    List {
        Section {
            ListRow(
                title: "Profile",
                subtitle: "John Doe"
            ) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(Color(.systemGray))
            } trailing: {
                EmptyView()
            } action: {
                print("Profile tapped")
            }
        }

        Section {
            ListRow(title: "Account Settings") {
                EmptyView()
            } trailing: {
                Text("Premium")
                    .font(.abcGinto(style: .caption, weight: .medium))
                    .foregroundStyle(Tokens.Color.violet.color)
            } action: {
                print("Settings tapped")
            }

            ListRow(
                title: "Notifications",
                subtitle: "Manage your notification preferences"
            ) {
                EmptyView()
            } trailing: {
                EmptyView()
            } action: {
                print("Notifications tapped")
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview("Settings Rows") {
    @Previewable @State var notificationsOn = true
    @Previewable @State var biometricsOn = false

    return List {
        Section {
            SettingsRow(
                icon: "person.fill",
                iconColor: .blue,
                title: "Account",
                value: "Premium"
            ) {
                print("Account")
            }

            SettingsRow(
                icon: "bell.fill",
                iconColor: .red,
                title: "Notifications"
            ) {
                print("Notifications")
            }

            SettingsRow(
                icon: "lock.fill",
                iconColor: .green,
                title: "Privacy"
            ) {
                print("Privacy")
            }
        }

        Section {
            ToggleRow(
                icon: "bell.fill",
                iconColor: .orange,
                title: "Push Notifications",
                subtitle: "Receive alerts about your transactions",
                isOn: $notificationsOn
            )

            ToggleRow(
                icon: "faceid",
                iconColor: .green,
                title: "Face ID",
                isOn: $biometricsOn
            )
        }
    }
}

#Preview("Info & Action Rows") {
    VStack(spacing: 0) {
        InfoRow(label: "Status", value: "Confirmed", valueColor: .green)
        Divider()
        InfoRow(label: "Amount", value: "0.00123 BTC")
        Divider()
        InfoRow(label: "Transaction ID", value: "abc123...xyz789", isCopyable: true)
        Divider()

        VStack(spacing: 0) {
            ActionRow(
                icon: "square.and.arrow.up",
                title: "Share"
            ) {
                print("Share")
            }

            ActionRow(
                icon: "doc.on.doc",
                title: "Copy Address"
            ) {
                print("Copy")
            }

            ActionRow(
                icon: "trash",
                title: "Delete",
                isDestructive: true
            ) {
                print("Delete")
            }
        }
    }
    .padding(.horizontal)
}
