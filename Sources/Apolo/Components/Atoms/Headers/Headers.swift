//
//  Headers.swift
//  Apolo
//
//  Created by Apolo on 2025.
//

import SwiftUI

// MARK: - NavigationHeader

public struct NavigationHeader<Leading: View, Trailing: View>: View {
    let title: String
    let subtitle: String?
    let leading: Leading
    let trailing: Trailing

    public init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder leading: () -> Leading = { EmptyView() },
        @ViewBuilder trailing: () -> Trailing = { EmptyView() }
    ) {
        self.title = title
        self.subtitle = subtitle
        self.leading = leading()
        self.trailing = trailing()
    }

    public var body: some View {
        HStack(spacing: Tokens.Spacing.medium) {
            leading
                .frame(minWidth: 44)

            Spacer()

            VStack(spacing: 0) {
                Text(title)
                    .font(.abcGinto(style: .headline, weight: .bold))
                    .foregroundStyle(Color(.label))

                if let subtitle {
                    Text(subtitle)
                        .font(.abcGinto(style: .caption, weight: .regular))
                        .foregroundStyle(Color(.secondaryLabel))
                }
            }

            Spacer()

            trailing
                .frame(minWidth: 44)
        }
        .padding(.horizontal, Tokens.Spacing.medium)
        .padding(.vertical, Tokens.Spacing.small)
        .background(Color(.systemBackground))
    }
}

// MARK: - BackButton

public struct BackButton: View {
    let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color(.label))
        }
        .modifier(HapticFeedbackModifier(style: .light))
    }
}

// MARK: - CloseButton

public struct CloseButton: View {
    let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Color(.secondaryLabel))
                .frame(width: 30, height: 30)
                .background(Color(.tertiarySystemFill))
                .clipShape(Circle())
        }
        .modifier(HapticFeedbackModifier(style: .light))
    }
}

// MARK: - SectionHeader

public struct SectionHeader: View {
    let title: String
    let subtitle: String?
    let actionLabel: String?
    let action: (() -> Void)?

    public init(
        title: String,
        subtitle: String? = nil,
        actionLabel: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.actionLabel = actionLabel
        self.action = action
    }

    public var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: Tokens.Spacing.extraExtraSmall) {
                Text(title)
                    .font(.abcGinto(style: .title3, weight: .bold))
                    .foregroundStyle(Color(.label))

                if let subtitle {
                    Text(subtitle)
                        .font(.abcGinto(style: .subheadline, weight: .regular))
                        .foregroundStyle(Color(.secondaryLabel))
                }
            }

            Spacer()

            if let actionLabel, let action {
                Button {
                    action()
                } label: {
                    Text(actionLabel)
                        .font(.abcGinto(style: .subheadline, weight: .medium))
                        .foregroundStyle(Tokens.Color.violet.color)
                }
            }
        }
    }
}

// MARK: - PageHeader

public struct PageHeader: View {
    let title: String
    let subtitle: String?

    public init(
        title: String,
        subtitle: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.extraSmall) {
            Text(title)
                .extraLargeTitle2()
                .foregroundStyle(Color(.label))

            if let subtitle {
                Text(subtitle)
                    .font(.abcGinto(style: .body, weight: .regular))
                    .foregroundStyle(Color(.secondaryLabel))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - ListHeader

public struct ListHeader: View {
    let title: String

    public init(_ title: String) {
        self.title = title
    }

    public var body: some View {
        Text(title.uppercased())
            .caption1(weight: .medium)
            .foregroundStyle(Color(.secondaryLabel))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Tokens.Spacing.medium)
            .padding(.top, Tokens.Spacing.large)
            .padding(.bottom, Tokens.Spacing.extraSmall)
    }
}

// MARK: - Preview

#Preview("Navigation Headers") {
    VStack(spacing: Tokens.Spacing.large) {
        NavigationHeader(title: "Settings") {
            BackButton { print("Back") }
        } trailing: {
            EmptyView()
        }

        NavigationHeader(
            title: "Bitcoin Wallet",
            subtitle: "Main Account"
        ) {
            BackButton { print("Back") }
        } trailing: {
            Button {
                print("More")
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18))
            }
        }

        NavigationHeader(title: "Confirm Transaction") {
            EmptyView()
        } trailing: {
            CloseButton { print("Close") }
        }
    }
}

#Preview("Section Headers") {
    VStack(spacing: Tokens.Spacing.large) {
        SectionHeader(title: "Recent Transactions")

        SectionHeader(
            title: "Activity",
            subtitle: "Last 30 days",
            actionLabel: "See All"
        ) {
            print("See all")
        }

        Divider()

        PageHeader(
            title: "Welcome back",
            subtitle: "Here's what's happening with your account today"
        )

        Divider()

        VStack(spacing: 0) {
            ListHeader("Account")
            Text("Content here")
                .padding()
        }
    }
    .padding()
}
