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

    @State private var expanded = false

    public struct Row: Identifiable {
        public let id = UUID()
        public let label: String
        public let value: String

        public init(label: String, value: String) {
            self.label = label
            self.value = value
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
                HStack(alignment: .center) {
                    Text(row.label)
                        .footnote()
                        .foregroundStyle(Tokens.Color.secondaryLabel.color)

                    Spacer()

                    Text(row.value)
                        .callout()
                        .foregroundStyle(Tokens.Color.label.color)
                        .multilineTextAlignment(.trailing)
                }
                .padding(.horizontal, Tokens.Spacing.medium)
                .padding(.vertical, Tokens.Spacing.small)

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
                    .foregroundStyle(Tokens.Color.violet.color)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Tokens.Spacing.small)
                }
                .buttonStyle(.plain)
            }
        }
        .cardBackground(.secondary, cornerRadius: Tokens.CornerRadius.medium)
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
    }
    .padding()
}
