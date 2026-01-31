//
//  BottomSheet.swift
//  Apolo
//
//  Created by Apolo on 2025.
//

import SwiftUI

// MARK: - SheetDetent

public enum SheetDetent: Equatable, Hashable {
    case small
    case medium
    case large
    case fraction(CGFloat)

    var heightFraction: CGFloat {
        switch self {
        case .small: return 0.25
        case .medium: return 0.5
        case .large: return 0.9
        case .fraction(let value): return min(max(value, 0.1), 1.0)
        }
    }
}

// MARK: - SheetHandle

public struct SheetHandle: View {
    let width: CGFloat
    let height: CGFloat
    let color: Color

    public init(
        width: CGFloat = 36,
        height: CGFloat = 5,
        color: Color = Color(.tertiaryLabel)
    ) {
        self.width = width
        self.height = height
        self.color = color
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: height / 2)
            .fill(color)
            .frame(width: width, height: height)
            .padding(.top, Tokens.Spacing.extraSmall)
            .padding(.bottom, Tokens.Spacing.small)
    }
}

// MARK: - BottomSheetModifier

public struct BottomSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let detents: [SheetDetent]
    let showHandle: Bool
    let showCloseButton: Bool
    let onDismiss: (() -> Void)?
    let sheetContent: () -> SheetContent

    @State private var currentDetent: SheetDetent = .medium
    @State private var dragOffset: CGFloat = 0

    public init(
        isPresented: Binding<Bool>,
        detents: [SheetDetent] = [.medium, .large],
        showHandle: Bool = true,
        showCloseButton: Bool = false,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder sheetContent: @escaping () -> SheetContent
    ) {
        self._isPresented = isPresented
        self.detents = detents.isEmpty ? [.medium] : detents
        self.showHandle = showHandle
        self.showCloseButton = showCloseButton
        self.onDismiss = onDismiss
        self.sheetContent = sheetContent
        self._currentDetent = State(initialValue: detents.first ?? .medium)
    }

    public func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if isPresented {
                        Color.black
                            .opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                dismiss()
                            }
                            .transition(.opacity)
                    }
                }
            )
            .overlay(alignment: .bottom) {
                if isPresented {
                    GeometryReader { geometry in
                        let maxHeight = geometry.size.height * currentDetent.heightFraction

                        VStack(spacing: 0) {
                            if showHandle {
                                SheetHandle()
                            }

                            if showCloseButton {
                                HStack {
                                    Spacer()
                                    CloseButton {
                                        dismiss()
                                    }
                                }
                                .padding(.horizontal, Tokens.Spacing.medium)
                            }

                            sheetContent()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .frame(height: maxHeight + dragOffset)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: Tokens.CornerRadius.large)
                                .fill(Color(.systemBackground))
                                .ignoresSafeArea(edges: .bottom)
                        )
                        .shadow(.large)
                        .offset(y: geometry.size.height - maxHeight - dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let translation = -value.translation.height
                                    dragOffset = translation
                                }
                                .onEnded { value in
                                    let velocity = -value.predictedEndTranslation.height
                                    handleDragEnd(velocity: velocity, geometry: geometry)
                                }
                        )
                        .transition(.move(edge: .bottom))
                    }
                }
            }
            .animation(Tokens.Animation.spring, value: isPresented)
            .animation(Tokens.Animation.spring, value: currentDetent)
    }

    private func handleDragEnd(velocity: CGFloat, geometry: GeometryProxy) {
        let currentHeight = geometry.size.height * currentDetent.heightFraction + dragOffset

        // If dragged down significantly or with velocity, dismiss
        if dragOffset < -100 || velocity < -500 {
            dismiss()
            return
        }

        // Find the closest detent
        var closestDetent = currentDetent
        var closestDistance: CGFloat = .infinity

        for detent in detents {
            let detentHeight = geometry.size.height * detent.heightFraction
            let distance = abs(currentHeight - detentHeight)

            if distance < closestDistance {
                closestDistance = distance
                closestDetent = detent
            }
        }

        withAnimation(Tokens.Animation.spring) {
            currentDetent = closestDetent
            dragOffset = 0
        }
    }

    private func dismiss() {
        withAnimation(Tokens.Animation.spring) {
            isPresented = false
            dragOffset = 0
        }
        onDismiss?()
    }
}

public extension View {
    func bottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        detents: [SheetDetent] = [.medium, .large],
        showHandle: Bool = true,
        showCloseButton: Bool = false,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(
            BottomSheetModifier(
                isPresented: isPresented,
                detents: detents,
                showHandle: showHandle,
                showCloseButton: showCloseButton,
                onDismiss: onDismiss,
                sheetContent: content
            )
        )
    }
}

// MARK: - ActionSheet

public struct ActionSheetItem: Identifiable {
    public let id = UUID()
    public let title: String
    public let icon: String?
    public let style: ActionSheetItemStyle
    public let action: () -> Void

    public init(
        title: String,
        icon: String? = nil,
        style: ActionSheetItemStyle = .default,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.action = action
    }
}

public enum ActionSheetItemStyle {
    case `default`
    case destructive
    case cancel
}

public struct ActionSheet: View {
    let title: String?
    let message: String?
    let items: [ActionSheetItem]
    let onDismiss: () -> Void

    public init(
        title: String? = nil,
        message: String? = nil,
        items: [ActionSheetItem],
        onDismiss: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.items = items
        self.onDismiss = onDismiss
    }

    public var body: some View {
        VStack(spacing: Tokens.Spacing.small) {
            if title != nil || message != nil {
                VStack(spacing: Tokens.Spacing.extraExtraSmall) {
                    if let title {
                        Text(title)
                            .font(.abcGinto(style: .headline, weight: .bold))
                            .foregroundStyle(Color(.label))
                    }

                    if let message {
                        Text(message)
                            .font(.abcGinto(style: .subheadline, weight: .regular))
                            .foregroundStyle(Color(.secondaryLabel))
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.bottom, Tokens.Spacing.small)
            }

            VStack(spacing: 0) {
                ForEach(items.filter { $0.style != .cancel }) { item in
                    actionButton(for: item)

                    if item.id != items.filter({ $0.style != .cancel }).last?.id {
                        Divider()
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: Tokens.CornerRadius.medium)
                    .fill(Color(.secondarySystemBackground))
            )

            // Cancel button(s)
            ForEach(items.filter { $0.style == .cancel }) { item in
                Button {
                    item.action()
                    onDismiss()
                } label: {
                    Text(item.title)
                        .font(.abcGinto(style: .body, weight: .bold))
                        .foregroundStyle(Color(.systemBlue))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Tokens.Spacing.medium)
                }
                .background(
                    RoundedRectangle(cornerRadius: Tokens.CornerRadius.medium)
                        .fill(Color(.secondarySystemBackground))
                )
            }
        }
        .padding(.horizontal, Tokens.Spacing.small)
        .padding(.bottom, Tokens.Spacing.medium)
    }

    @ViewBuilder
    private func actionButton(for item: ActionSheetItem) -> some View {
        Button {
            item.action()
            onDismiss()
        } label: {
            HStack(spacing: Tokens.Spacing.small) {
                if let icon = item.icon {
                    Image(systemName: icon)
                        .font(.system(size: 18))
                }

                Text(item.title)
                    .font(.abcGinto(style: .body, weight: .regular))
            }
            .foregroundStyle(item.style == .destructive ? Color(.systemRed) : Color(.label))
            .frame(maxWidth: .infinity)
            .padding(.vertical, Tokens.Spacing.medium)
        }
    }
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview("Bottom Sheet") {
    @Previewable @State var showSheet = false

    ZStack {
        VStack {
            Button("Show Bottom Sheet") {
                showSheet = true
            }
            .borderedProminentStyle(color: Tokens.Color.violet.color)
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .bottomSheet(isPresented: $showSheet, detents: [.medium, .large]) {
        VStack(spacing: Tokens.Spacing.large) {
            PageHeader(
                title: "Bottom Sheet",
                subtitle: "This is a customizable bottom sheet"
            )

            Text("Content goes here")
                .foregroundStyle(Color(.secondaryLabel))

            Spacer()

            Button("Close") {
                showSheet = false
            }
            .borderedProminentStyle(color: Tokens.Color.violet.color)
        }
        .padding()
    }
}

@available(iOS 17.0, *)
#Preview("Action Sheet") {
    @Previewable @State var showAction = true

    ActionSheet(
        title: "Share Transaction",
        message: "Choose how you want to share this transaction",
        items: [
            ActionSheetItem(title: "Copy Link", icon: "link") {
                print("Copy")
            },
            ActionSheetItem(title: "Share via Message", icon: "message") {
                print("Message")
            },
            ActionSheetItem(title: "Delete", icon: "trash", style: .destructive) {
                print("Delete")
            },
            ActionSheetItem(title: "Cancel", style: .cancel) {
                print("Cancel")
            }
        ],
        onDismiss: { showAction = false }
    )
    .padding()
}
