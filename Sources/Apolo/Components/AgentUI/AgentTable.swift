//
//  AgentTable.swift
//  Apolo
//
//  Key-value detail rows with "Ver mais" expand.
//  Used for confirmation details, settings, transaction info.
//

import SwiftUI

// MARK: - Agent Table

public struct AgentTable: View {
    public let rows: [Row]
    public let maxVisible: Int?

    @Environment(\.openURL) private var openURL
    @State private var expanded = false

    public struct Row: Identifiable {
        public let id = UUID()
        public let label: String
        public let value: String
        public let url: URL?

        public init(label: String, value: String, url: URL? = nil) {
            self.label = label
            self.value = value
            self.url = url
        }
    }

    public init(rows: [Row], maxVisible: Int? = nil) {
        self.rows = rows
        self.maxVisible = maxVisible
    }

    private var visibleRows: [Row] {
        if expanded || maxVisible == nil { return rows }
        return Array(rows.prefix(maxVisible!))
    }

    private var hasMore: Bool {
        guard let max = maxVisible else { return false }
        return !expanded && rows.count > max
    }

    public var body: some View {
        VStack(spacing: .zero) {
            ForEach(Array(visibleRows.enumerated()), id: \.element.id) { idx, row in
                if let url = row.url {
                    Button {
                        openURL(url)
                    } label: {
                        rowContent(row)
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(.isLink)
                } else {
                    rowContent(row)
                }

                if idx < visibleRows.count - 1 || hasMore {
                    Separator()
                        .padding(.horizontal, Tokens.Spacing.medium)
                }
            }

            if hasMore {
                Button {
                    withAnimation(.easeOut(duration: 0.25)) {
                        expanded = true
                    }
                } label: {
                    HStack(spacing: Tokens.Spacing.extraExtraSmall) {
                        Text("Ver mais")
                            .subheadline(weight: .medium)
                        Image(systemName: "chevron.down")
                            .caption2()
                    }
                    .foregroundStyle(AgentSemanticColor.accent.color)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Tokens.Spacing.small)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, Tokens.Spacing.extraExtraSmall)
        .cardBackground(.secondary, cornerRadius: Tokens.CornerRadius.medium, glassEnabled: false)
    }

    private func rowContent(_ row: Row) -> some View {
        HStack(alignment: .center) {
            Text(row.label)
                .footnote()
                .foregroundStyle(Tokens.Color.secondaryLabel.color)

            Spacer()

            Text(row.value)
                .callout()
                .foregroundStyle(row.url != nil ? AgentSemanticColor.accent.color : Tokens.Color.label.color)
                .multilineTextAlignment(.trailing)

            if row.url != nil {
                Image(systemName: "arrow.up.right")
                    .small()
                    .foregroundStyle(Tokens.Color.tertiaryLabel.color)
            }
        }
        .padding(.horizontal, Tokens.Spacing.medium)
        .padding(.vertical, Tokens.Spacing.small)
        .contentShape(Rectangle())
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: Tokens.Spacing.medium) {
        AgentTable(rows: [
            .init(label: "Destinatário", value: "João Silva"),
            .init(label: "CPF", value: "***8900"),
            .init(label: "Banco", value: "Nubank"),
            .init(label: "Tipo", value: "Chave CPF"),
            .init(label: "Origem", value: "Conta corrente"),
        ], maxVisible: 3)

        AgentTable(rows: [
            .init(label: "Ativo", value: "PIX"),
            .init(label: "Período", value: "Diurno"),
        ])

        AgentTable(rows: [
            .init(label: "Código", value: "YHBRRY"),
            .init(label: "Convites", value: "5"),
            .init(label: "Link", value: "bipa.app/convite/YHBRRY", url: URL(string: "https://bipa.app/convite/YHBRRY")),
        ])
    }
    .padding()
}
