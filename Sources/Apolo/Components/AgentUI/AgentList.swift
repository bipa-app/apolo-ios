//
//  AgentList.swift
//  Apolo
//
//  Item rows with expand-to-sheet.
//  Used for transactions, contacts, statements.
//

import SwiftUI

// MARK: - Agent List

public struct AgentList: View {
    public let items: [Item]
    public let maxVisible: Int
    public let expandLabel: String?

    @State private var showSheet = false

    public struct Item: Identifiable {
        public let id: String
        public let title: String
        public let subtitle: String?
        public let trailing: String?
        public let trailingColor: Color?
        public let icon: String?

        public init(
            id: String = UUID().uuidString,
            title: String,
            subtitle: String? = nil,
            trailing: String? = nil,
            trailingColor: Color? = nil,
            icon: String? = nil
        ) {
            self.id = id
            self.title = title
            self.subtitle = subtitle
            self.trailing = trailing
            self.trailingColor = trailingColor
            self.icon = icon
        }
    }

    public init(items: [Item], maxVisible: Int = 3, expandLabel: String? = nil) {
        self.items = items
        self.maxVisible = maxVisible
        self.expandLabel = expandLabel
    }

    private var inlineItems: [Item] { Array(items.prefix(maxVisible)) }
    private var hasMore: Bool { items.count > maxVisible }

    public var body: some View {
        VStack(spacing: .zero) {
            ForEach(Array(inlineItems.enumerated()), id: \.element.id) { idx, item in
                AgentListRow(item: item)

                if idx < inlineItems.count - 1 || hasMore {
                    Separator()
                        .padding(.horizontal, Tokens.Spacing.medium)
                }
            }

            if hasMore {
                Button {
                    showSheet = true
                } label: {
                    HStack(spacing: Tokens.Spacing.extraSmall) {
                        Image(systemName: "list.bullet")
                            .small()
                        Text(expandLabel ?? "Ver todas (\(items.count))")
                            .subheadline(weight: .medium)
                    }
                    .foregroundStyle(Tokens.Color.violet.color)
                    .frame(maxWidth: .infinity)
                    .padding(Tokens.Spacing.medium)
                }
                .buttonStyle(.plain)
            }
        }
        .cardBackground()
        .sheet(isPresented: $showSheet) {
            AgentListSheet(items: items)
        }
    }
}

// MARK: - Row

public struct AgentListRow: View {
    public let item: AgentList.Item

    public init(item: AgentList.Item) {
        self.item = item
    }

    public var body: some View {
        HStack(spacing: Tokens.Spacing.small) {
            if let icon = item.icon {
                Image(systemName: icon)
                    .large()
                    .foregroundStyle(Tokens.Color.secondaryLabel.color)
                    .frame(width: 28, height: 28)
            }

            VStack(alignment: .leading, spacing: Tokens.Spacing.extraExtraSmall) {
                Text(item.title)
                    .callout()
                    .foregroundStyle(Tokens.Color.label.color)
                    .lineLimit(1)

                if let subtitle = item.subtitle {
                    Text(subtitle)
                        .subheadline()
                        .foregroundStyle(Tokens.Color.secondaryLabel.color)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if let trailing = item.trailing {
                Text(trailing)
                    .headline()
                    .foregroundStyle(item.trailingColor ?? Tokens.Color.label.color)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .monospacedDigit()
            }
        }
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
        .padding(.horizontal, Tokens.Spacing.medium)
        .padding(.vertical, Tokens.Spacing.small)
    }
}

// MARK: - Sheet

private struct AgentListSheet: View {
    let items: [AgentList.Item]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: .zero) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { idx, item in
                        AgentListRow(item: item)

                        if idx < items.count - 1 {
                            Separator()
                                .padding(.horizontal, Tokens.Spacing.medium)
                        }
                    }
                }
                .cardBackground()
                .padding(.horizontal, Tokens.Spacing.medium)
                .padding(.vertical, Tokens.Spacing.small)
            }
            .background(Color(.systemGroupedBackground))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Tokens.Color.secondaryLabel.color)
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Preview

#Preview {
    AgentList(
        items: [
            .init(title: "PIX para Maria Silva", subtitle: "18/03 14:32", trailing: "R$ 250", trailingColor: Tokens.Color.red.color, icon: "arrow.up.right"),
            .init(title: "PIX recebido de João", subtitle: "18/03 10:15", trailing: "+R$ 1.500", trailingColor: Tokens.Color.green.color, icon: "arrow.down.left"),
            .init(title: "iFood", subtitle: "17/03 20:45", trailing: "R$ 45,90", icon: "creditcard"),
            .init(title: "Compra Bitcoin", subtitle: "17/03 09:00", trailing: "R$ 500", icon: "bitcoinsign.circle"),
            .init(title: "Aluguel", subtitle: "15/03 08:00", trailing: "R$ 2.500", trailingColor: Tokens.Color.red.color, icon: "arrow.up.right"),
        ],
        maxVisible: 3,
        expandLabel: "Ver todas (20)"
    )
    .padding()
}
