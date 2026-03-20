//
//  AgentDocumentPreview.swift
//  Apolo
//
//  Preview card that shows a clipped snapshot of the document.
//  Tap zooms into the full document view.
//

import SwiftUI

// MARK: - Agent Document Preview

/// Shows a clipped preview of the document content. Tapping zooms
/// into the full-screen document view with a matched geometry transition.
public struct AgentDocumentPreview<Content: View>: View {
    public let title: String
    public let preview: String?
    @ViewBuilder public let document: () -> Content

    @State private var showDocument = false
    @Namespace private var documentNamespace

    public init(
        title: String,
        preview: String? = nil,
        @ViewBuilder document: @escaping () -> Content
    ) {
        self.title = title
        self.preview = preview
        self.document = document
    }

    public var body: some View {
        Button {
            showDocument = true
        } label: {
            previewCard
        }
        .buttonStyle(.plain)
        .fullScreenCover(isPresented: $showDocument) {
            documentSheet
        }
    }

    // MARK: - Preview Card

    private var previewCard: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.zero) {
            // Clipped snapshot of the actual document content
            document()
                .frame(maxHeight: 160)
                .clipped()
                .allowsHitTesting(false)

            // Fade-out gradient at the bottom of the preview
            LinearGradient(
                colors: [
                    Tokens.Color.secondarySystemGroupedBackground.color.opacity(0),
                    Tokens.Color.secondarySystemGroupedBackground.color
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 32)
            .offset(y: -32)
            .padding(.bottom, -32)

            // Title bar
            HStack(spacing: Tokens.Spacing.small) {
                Image(systemName: "doc.text.fill")
                    .regular()
                    .foregroundStyle(AgentSemanticColor.accent.color)

                VStack(alignment: .leading, spacing: Tokens.Spacing.zero) {
                    Text(title)
                        .callout(weight: .medium)
                        .foregroundStyle(Tokens.Color.label.color)
                        .lineLimit(1)

                    if let preview {
                        Text(preview)
                            .caption1()
                            .foregroundStyle(Tokens.Color.secondaryLabel.color)
                            .lineLimit(1)
                    }
                }

                Spacer()

                Text("Abrir")
                    .subheadline(weight: .medium)
                    .foregroundStyle(AgentSemanticColor.accent.color)
            }
            .padding(.horizontal, Tokens.Spacing.medium)
            .padding(.vertical, Tokens.Spacing.small)
        }
        .cardBackground()
        .matchedGeometryEffect(id: "document", in: documentNamespace)
    }

    // MARK: - Full Document Sheet

    private var documentSheet: some View {
        NavigationStack {
            ScrollView {
                document()
                    .padding(.horizontal, Tokens.Spacing.medium)
                    .padding(.vertical, Tokens.Spacing.small)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(title)
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button { showDocument = false } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Tokens.Color.secondaryLabel.color)
                    }
                }
            }
        }
        .matchedGeometryEffect(id: "document", in: documentNamespace)
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Preview

#Preview("Document Preview") {
    ScrollView {
        AgentDocumentPreview(title: "Relatório de gastos — Março 2026", preview: "R$ 4.523,00 em 47 transações") {
            VStack(spacing: Tokens.Spacing.medium) {
                AgentCard {
                    AgentMetric(label: "Total gasto", value: "R$ 4.523,00", caption: "+12% vs fevereiro", captionColor: Tokens.Color.red.color)
                }
                AgentCard(title: "Por categoria") {
                    AgentList(items: [
                        .init(title: "Alimentação", subtitle: "23 transações", trailing: "R$ 1.200", icon: "fork.knife"),
                        .init(title: "Transporte", subtitle: "12 transações", trailing: "R$ 800", icon: "car.fill"),
                    ], maxVisible: 10)
                }
            }
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}
