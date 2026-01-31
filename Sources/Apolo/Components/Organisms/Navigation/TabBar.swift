//
//  TabBar.swift
//  Apolo
//
//  Created by Apolo on 2025.
//

import SwiftUI

// MARK: - TabItem

public struct TabItem: Identifiable, Equatable {
    public let id: String
    public let icon: String
    public let selectedIcon: String
    public let label: String
    public let badge: Int?

    public init(
        id: String,
        icon: String,
        selectedIcon: String? = nil,
        label: String,
        badge: Int? = nil
    ) {
        self.id = id
        self.icon = icon
        self.selectedIcon = selectedIcon ?? icon + ".fill"
        self.label = label
        self.badge = badge
    }

    public static func == (lhs: TabItem, rhs: TabItem) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - CustomTabBar

public struct CustomTabBar: View {
    let items: [TabItem]
    @Binding var selectedId: String
    let onTap: ((TabItem) -> Void)?

    public init(
        items: [TabItem],
        selectedId: Binding<String>,
        onTap: ((TabItem) -> Void)? = nil
    ) {
        self.items = items
        self._selectedId = selectedId
        self.onTap = onTap
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(items) { item in
                TabBarButton(
                    item: item,
                    isSelected: selectedId == item.id
                ) {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    withAnimation(Tokens.Animation.bouncy) {
                        selectedId = item.id
                    }
                    onTap?(item)
                }
            }
        }
        .padding(.horizontal, Tokens.Spacing.medium)
        .padding(.top, Tokens.Spacing.small)
        .padding(.bottom, Tokens.Spacing.extraSmall)
        .background(
            Rectangle()
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, y: -4)
        )
    }
}

// MARK: - TabBarButton

private struct TabBarButton: View {
    let item: TabItem
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            VStack(spacing: Tokens.Spacing.extraExtraSmall) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: isSelected ? item.selectedIcon : item.icon)
                        .font(.system(size: 22))
                        .symbolRenderingMode(.hierarchical)

                    if let badge = item.badge, badge > 0 {
                        BadgeView(count: badge)
                            .offset(x: 8, y: -4)
                    }
                }

                Text(item.label)
                    .font(.abcGinto(style: .caption2, weight: isSelected ? .medium : .regular))
            }
            .foregroundStyle(isSelected ? Tokens.Color.violet.color : Color(.secondaryLabel))
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - BadgeView

public struct BadgeView: View {
    let count: Int
    let maxCount: Int
    let backgroundColor: Color

    public init(
        count: Int,
        maxCount: Int = 99,
        backgroundColor: Color = Color(.systemRed)
    ) {
        self.count = count
        self.maxCount = maxCount
        self.backgroundColor = backgroundColor
    }

    private var displayText: String {
        count > maxCount ? "\(maxCount)+" : "\(count)"
    }

    public var body: some View {
        Text(displayText)
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 5)
            .padding(.vertical, 2)
            .background(backgroundColor)
            .clipShape(Capsule())
            .fixedSize()
    }
}

// MARK: - FloatingTabBar

public struct FloatingTabBar: View {
    let items: [TabItem]
    @Binding var selectedId: String

    public init(
        items: [TabItem],
        selectedId: Binding<String>
    ) {
        self.items = items
        self._selectedId = selectedId
    }

    public var body: some View {
        HStack(spacing: Tokens.Spacing.large) {
            ForEach(items) { item in
                Button {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    withAnimation(Tokens.Animation.bouncy) {
                        selectedId = item.id
                    }
                } label: {
                    VStack(spacing: Tokens.Spacing.extraExtraSmall) {
                        Image(systemName: selectedId == item.id ? item.selectedIcon : item.icon)
                            .font(.system(size: 20))
                            .symbolRenderingMode(.hierarchical)

                        if selectedId == item.id {
                            Circle()
                                .fill(Tokens.Color.violet.color)
                                .frame(width: 5, height: 5)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .foregroundStyle(selectedId == item.id ? Tokens.Color.violet.color : Color(.secondaryLabel))
                    .frame(width: 50, height: 50)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, Tokens.Spacing.large)
        .padding(.vertical, Tokens.Spacing.small)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .shadow(.medium)
        )
    }
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview("Custom Tab Bar") {
    @Previewable @State var selected = "home"

    let items: [TabItem] = [
        TabItem(id: "home", icon: "house", label: "Home"),
        TabItem(id: "wallet", icon: "wallet.pass", label: "Wallet", badge: 2),
        TabItem(id: "activity", icon: "clock.arrow.circlepath", label: "Activity"),
        TabItem(id: "settings", icon: "gearshape", label: "Settings")
    ]

    VStack {
        Spacer()
        Text("Selected: \(selected)")
        Spacer()
        CustomTabBar(items: items, selectedId: $selected)
    }
}

@available(iOS 17.0, *)
#Preview("Floating Tab Bar") {
    @Previewable @State var selected = "home"

    let items: [TabItem] = [
        TabItem(id: "home", icon: "house", label: "Home"),
        TabItem(id: "wallet", icon: "wallet.pass", label: "Wallet"),
        TabItem(id: "settings", icon: "gearshape", label: "Settings")
    ]

    ZStack {
        Color(.systemBackground)
            .ignoresSafeArea()

        VStack {
            Spacer()
            FloatingTabBar(items: items, selectedId: $selected)
                .padding(.bottom, Tokens.Spacing.large)
        }
    }
}

#Preview("Badge View") {
    HStack(spacing: Tokens.Spacing.large) {
        BadgeView(count: 1)
        BadgeView(count: 9)
        BadgeView(count: 42)
        BadgeView(count: 100)
    }
    .padding()
}
