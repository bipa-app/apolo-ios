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
        ZStack(alignment: .bottomLeading) {
            // Content snapshot — pinned to top
            VStack(alignment: .leading, spacing: 0) {
                document()
                    .allowsHitTesting(false)
            }
            .frame(height: 200, alignment: .top)
            .clipped()

            // Gradient scrim — stronger opacity for readability
            LinearGradient(
                colors: [.clear, .black.opacity(0.85)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 100)

            // Overlaid title
            VStack(alignment: .leading, spacing: Tokens.Spacing.extraExtraSmall) {
                Text(title)
                    .callout(weight: .medium)
                    .foregroundStyle(.white)
                    .lineLimit(1)

                if let preview {
                    Text(preview)
                        .caption1()
                        .foregroundStyle(.white.opacity(0.75))
                        .lineLimit(1)
                }
            }
            .padding(.horizontal, Tokens.Spacing.medium)
            .padding(.bottom, Tokens.Spacing.small)
        }
        .clipShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.large))
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
        .matchedGeometryEffect(id: "document", in: documentNamespace)
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Preview Variants

/// Preview helper — material overlay on the ENTIRE card (content + title).
private struct DocumentPreviewMaterialOverlay<Content: View, M: ShapeStyle>: View {
    let title: String
    let preview: String?
    let material: M
    let label: String
    @ViewBuilder let document: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.extraSmall) {
            Text(label)
                .caption1(weight: .medium)
                .foregroundStyle(Tokens.Color.secondaryLabel.color)

            ZStack(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 0) {
                    document()
                        .allowsHitTesting(false)
                }
                .frame(height: 200, alignment: .top)
                .clipped()
                // Full-card overlay
                .overlay { Rectangle().fill(material) }

                // Title on top of the overlay
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
                .padding(.horizontal, Tokens.Spacing.medium)
                .padding(.bottom, Tokens.Spacing.small)
            }
            .clipShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.large))
            .cardBackground()
        }
    }
}

/// Preview helper — material only on the BOTTOM title bar.
private struct DocumentPreviewMaterialBar<Content: View, M: ShapeStyle>: View {
    let title: String
    let preview: String?
    let material: M
    let label: String
    @ViewBuilder let document: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.extraSmall) {
            Text(label)
                .caption1(weight: .medium)
                .foregroundStyle(Tokens.Color.secondaryLabel.color)

            ZStack(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 0) {
                    document()
                        .allowsHitTesting(false)
                }
                .frame(height: 200, alignment: .top)
                .clipped()

                // Material bar at the bottom only
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
                .padding(.vertical, Tokens.Spacing.small)
                .background(material)
            }
            .clipShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.large))
            .cardBackground()
        }
    }
}

/// Preview helper — iOS 26 glass effect on the bottom title bar.
@available(iOS 26.0, *)
private struct DocumentPreviewGlassBar<Content: View>: View {
    let title: String
    let preview: String?
    let isClear: Bool
    let tint: Color?
    let label: String
    @ViewBuilder let document: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.extraSmall) {
            Text(label)
                .caption1(weight: .medium)
                .foregroundStyle(Tokens.Color.secondaryLabel.color)

            ZStack(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 0) {
                    document()
                        .allowsHitTesting(false)
                }
                .frame(height: 200, alignment: .top)
                .clipped()

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
                .padding(.vertical, Tokens.Spacing.small)
                .glassEffect(
                    isClear
                        ? .clear.tint(tint).interactive()
                        : .regular.tint(tint).interactive(),
                    in: .rect(cornerRadius: 0)
                )
            }
            .clipShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.large))
            .cardBackground()
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

private let previewTitle = "Relatório de gastos — Março 2026"
private let previewSubtitle = "R$ 4.523,00 em 47 transações"

// ── Current design ──

#Preview("Current — opacity scrim") {
    ScrollView {
        AgentDocumentPreview(title: previewTitle, preview: previewSubtitle) { SampleDocument() }
            .padding()
    }
    .background(Color(.systemGroupedBackground))
}

// ── Material on TITLE BAR only ──

#Preview("Bar — ultraThinMaterial") {
    ScrollView {
        DocumentPreviewMaterialBar(title: previewTitle, preview: previewSubtitle, material: .ultraThinMaterial, label: "Bar: ultraThin") { SampleDocument() }.padding()
    }.background(Color(.systemGroupedBackground))
}

#Preview("Bar — thinMaterial") {
    ScrollView {
        DocumentPreviewMaterialBar(title: previewTitle, preview: previewSubtitle, material: .thinMaterial, label: "Bar: thin") { SampleDocument() }.padding()
    }.background(Color(.systemGroupedBackground))
}

#Preview("Bar — regularMaterial") {
    ScrollView {
        DocumentPreviewMaterialBar(title: previewTitle, preview: previewSubtitle, material: .regularMaterial, label: "Bar: regular") { SampleDocument() }.padding()
    }.background(Color(.systemGroupedBackground))
}

#Preview("Bar — thickMaterial") {
    ScrollView {
        DocumentPreviewMaterialBar(title: previewTitle, preview: previewSubtitle, material: .thickMaterial, label: "Bar: thick") { SampleDocument() }.padding()
    }.background(Color(.systemGroupedBackground))
}

// ── Material on ENTIRE card ──

#Preview("Full — ultraThinMaterial") {
    ScrollView {
        DocumentPreviewMaterialOverlay(title: previewTitle, preview: previewSubtitle, material: .ultraThinMaterial, label: "Full overlay: ultraThin") { SampleDocument() }.padding()
    }.background(Color(.systemGroupedBackground))
}

#Preview("Full — thinMaterial") {
    ScrollView {
        DocumentPreviewMaterialOverlay(title: previewTitle, preview: previewSubtitle, material: .thinMaterial, label: "Full overlay: thin") { SampleDocument() }.padding()
    }.background(Color(.systemGroupedBackground))
}

#Preview("Full — regularMaterial") {
    ScrollView {
        DocumentPreviewMaterialOverlay(title: previewTitle, preview: previewSubtitle, material: .regularMaterial, label: "Full overlay: regular") { SampleDocument() }.padding()
    }.background(Color(.systemGroupedBackground))
}

// ── iOS 26 Liquid Glass on TITLE BAR ──

#Preview("Glass bar — .clear") {
    if #available(iOS 26.0, *) {
        ScrollView {
            DocumentPreviewGlassBar(title: previewTitle, preview: previewSubtitle, isClear: true, tint: nil, label: "Glass: .clear") { SampleDocument() }.padding()
        }.background(Color(.systemGroupedBackground))
    }
}

#Preview("Glass bar — .regular") {
    if #available(iOS 26.0, *) {
        ScrollView {
            DocumentPreviewGlassBar(title: previewTitle, preview: previewSubtitle, isClear: false, tint: nil, label: "Glass: .regular") { SampleDocument() }.padding()
        }.background(Color(.systemGroupedBackground))
    }
}

#Preview("Glass bar — .clear tint violet") {
    if #available(iOS 26.0, *) {
        ScrollView {
            DocumentPreviewGlassBar(title: previewTitle, preview: previewSubtitle, isClear: true, tint: Tokens.Color.violet.color, label: "Glass: .clear + violet tint") { SampleDocument() }.padding()
        }.background(Color(.systemGroupedBackground))
    }
}

#Preview("Glass bar — .regular tint violet") {
    if #available(iOS 26.0, *) {
        ScrollView {
            DocumentPreviewGlassBar(title: previewTitle, preview: previewSubtitle, isClear: false, tint: Tokens.Color.violet.color, label: "Glass: .regular + violet tint") { SampleDocument() }.padding()
        }.background(Color(.systemGroupedBackground))
    }
}

// ── Gallery: all side by side ──

#Preview("Gallery") {
    ScrollView {
        VStack(spacing: Tokens.Spacing.large) {
            DocumentPreviewMaterialBar(title: previewTitle, preview: previewSubtitle, material: .ultraThinMaterial, label: "Bar: ultraThin") { SampleDocument() }
            DocumentPreviewMaterialBar(title: previewTitle, preview: previewSubtitle, material: .regularMaterial, label: "Bar: regular") { SampleDocument() }
            DocumentPreviewMaterialOverlay(title: previewTitle, preview: previewSubtitle, material: .ultraThinMaterial, label: "Full: ultraThin") { SampleDocument() }
            DocumentPreviewMaterialOverlay(title: previewTitle, preview: previewSubtitle, material: .regularMaterial, label: "Full: regular") { SampleDocument() }
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}
