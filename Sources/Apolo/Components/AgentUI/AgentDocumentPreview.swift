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
    @Namespace private var zoomNamespace

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
        if #available(iOS 18.0, *) {
            previewCard
                .onTapGesture { showDocument = true }
                .matchedTransitionSource(id: "doc", in: zoomNamespace)
                .fullScreenCover(isPresented: $showDocument) {
                    documentSheet
                        .navigationTransition(.zoom(sourceID: "doc", in: zoomNamespace))
                }
        } else {
            Button { showDocument = true } label: { previewCard }
                .buttonStyle(.plain)
                .fullScreenCover(isPresented: $showDocument) { documentSheet }
        }
    }

    // MARK: - Preview Card

    private var previewCard: some View {
        ZStack(alignment: .bottomLeading) {
            // Content snapshot pinned to top
            VStack(alignment: .leading, spacing: 0) {
                document()
                    .allowsHitTesting(false)
            }
            .frame(height: 200, alignment: .top)
            .clipped()

            // Gradient frost: lightly frosted at top, fully frosted at bottom
            Rectangle()
                .fill(.regularMaterial)
                .mask(
                    LinearGradient(
                        stops: [
                            .init(color: .white.opacity(0.55), location: 0),
                            .init(color: .white.opacity(0.6), location: 0.3),
                            .init(color: .white.opacity(0.75), location: 0.55),
                            .init(color: .white, location: 0.75),
                            .init(color: .white, location: 1.0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            // Title at bottom (in the fully frosted area)
            VStack(alignment: .leading, spacing: Tokens.Spacing.extraExtraSmall) {
                Text(title)
                    .callout(weight: .medium)
                    .lineLimit(1)

                if let preview {
                    Text(preview)
                        .caption1()
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Tokens.Spacing.medium)
            .padding(.bottom, Tokens.Spacing.small)
        }
        .clipShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.large))
        .cardBackground()
    }

    // MARK: - Full Document

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
            .navigationBarTitleDisplayMode(.inline)
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
    }
}

// MARK: - Previews

private struct SampleDocument: View {
    var body: some View {
        VStack(spacing: Tokens.Spacing.medium) {
            AgentCard {
                AgentMetric(
                    label: "Total gasto",
                    value: "R$ 4.523,00",
                    caption: "+12% vs fevereiro",
                    captionColor: Tokens.Color.red.color,
                    icon: "chart.bar.fill",
                    iconColor: Tokens.Color.violet.color
                )
            }
            AgentCard(title: "Por categoria") {
                AgentList(items: [
                    .init(title: "Alimentação", subtitle: "23 transações", trailing: "R$ 1.200", icon: "fork.knife"),
                    .init(title: "Transporte", subtitle: "12 transações", trailing: "R$ 800", icon: "car.fill"),
                    .init(title: "Moradia", subtitle: "3 transações", trailing: "R$ 600", icon: "house.fill"),
                ], maxVisible: 10)
            }
        }
    }
}

#Preview("Document Preview") {
    ScrollView {
        AgentDocumentPreview(title: "Relatório de gastos — Março 2026", preview: "R$ 4.523,00 em 47 transações") {
            SampleDocument()
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}
