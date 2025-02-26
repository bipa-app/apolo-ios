//
//  Buttons.swift
//  Apolo
//
//  Created by Eric on 09/12/24.
//

import SwiftUI

public enum CustomButtonShape {
    case capsule
    case circle
    case roundedRectangle

    @available(iOS 17.0, *)
    public var toButtonBorderShape: ButtonBorderShape {
        switch self {
        case .capsule:
            return .capsule
        case .circle:
            return .circle
        case .roundedRectangle:
            return .roundedRectangle
        }
    }

    public var toViewShape: AnyShape {
        switch self {
        case .capsule:
            return AnyShape(Capsule())
        case .circle:
            return AnyShape(Circle())
        case .roundedRectangle:
            return AnyShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.small))
        }
    }

    public var toStrokeShape: AnyShape {
        switch self {
        case .capsule:
            return AnyShape(Capsule())
        case .circle:
            return AnyShape(Circle())
        case .roundedRectangle:
            return AnyShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.small))
        }
    }
}

public extension Button {
    func borderedProminentStyle(
        shape: CustomButtonShape = .capsule,
        color: Color = .green,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft
    ) -> some View {
        buttonStyle(.borderedProminent)
            .controlSize(size)
            .modifier(ButtonShapeModifier(shape: shape))
            .tint(color)
            .font(.abcGinto(style: .body, weight: .regular))
            .modifier(HapticFeedbackModifier(style: hapticStyle))
    }

    func borderedStyle(
        shape: CustomButtonShape = .capsule,
        color: Color = .green,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft
    ) -> some View {
        buttonStyle(.bordered)
            .controlSize(size)
            .modifier(ButtonShapeModifier(shape: shape))
            .tint(color)
            .font(.abcGinto(style: .body, weight: .regular))
            .modifier(HapticFeedbackModifier(style: hapticStyle))
    }

    func plainStyle(
        shape: CustomButtonShape = .capsule,
        color: Color = .green,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft
    ) -> some View {
        buttonStyle(.plain)
            .controlSize(size)
            .modifier(ButtonShapeModifier(shape: shape))
            .tint(color)
            .font(.abcGinto(style: .body, weight: .regular))
            .modifier(HapticFeedbackModifier(style: hapticStyle))
    }

    func strokedStyle(
        shape: CustomButtonShape = .capsule,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft
    ) -> some View {
        modifier(StrokedButtonModifier(shape: shape, size: size))
            .font(.abcGinto(style: .subheadline, weight: .regular))
            .modifier(HapticFeedbackModifier(style: hapticStyle))
    }
}

/// Extension to allow the creation of buttons with system images only
public extension Button {
    init(systemImage: String, action: @escaping () -> Void) where Label == Image {
        self.init(action: action) {
            Image(systemName: systemImage)
        }
    }
}

public struct ButtonShapeModifier: ViewModifier {
    let shape: CustomButtonShape

    public init(shape: CustomButtonShape) {
        self.shape = shape
    }

    public func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.buttonBorderShape(shape.toButtonBorderShape)
        } else {
            content.clipShape(shape.toViewShape)
        }
    }
}

public struct StrokedButtonModifier: ViewModifier {
    let shape: CustomButtonShape
    let size: ControlSize

    @Environment(\.isEnabled) private var isEnabled

    public init(shape: CustomButtonShape, size: ControlSize) {
        self.shape = shape
        self.size = size
    }

    private func sizeValues(for size: ControlSize) -> (height: CGFloat, padding: CGFloat) {
        switch size {
        case .small:
            return (28, 10)
        case .regular:
            return (35, 12)
        case .large:
            return (50, 20)
        default:
            return (32, 14)
        }
    }

    public func body(content: Content) -> some View {
        let sizes = sizeValues(for: size)

        content
            .tint(.primary)
            .foregroundStyle(.primary)
            .padding(.horizontal, sizes.padding)
            .frame(height: sizes.height)
            .overlay(
                Group {
                    switch self.shape {
                    case .capsule:
                        Capsule()
                            .strokeBorder(Color.primary.opacity(0.15), lineWidth: 1)
                    case .circle:
                        Circle()
                            .strokeBorder(Color.primary.opacity(0.15), lineWidth: 1)
                    case .roundedRectangle:
                        RoundedRectangle(cornerRadius: Tokens.CornerRadius.small)
                            .strokeBorder(Color.primary.opacity(0.15), lineWidth: 1)
                    }
                }
            )
            .opacity(isEnabled ? 1.0 : 0.5)
    }
}

public struct HapticFeedbackModifier: ViewModifier {
    let style: UIImpactFeedbackGenerator.FeedbackStyle

    public init(style: UIImpactFeedbackGenerator.FeedbackStyle = .soft) {
        self.style = style
    }

    public func body(content: Content) -> some View {
        content.simultaneousGesture(TapGesture().onEnded { _ in
            let impact = UIImpactFeedbackGenerator(style: self.style)
            impact.impactOccurred()
        })
    }
}

#Preview {
    VStack(spacing: 12) {
        Button("Bitcoin", systemImage: "bitcoinsign.circle.fill") {
            print("Hello")
        }
        .borderedProminentStyle(color: Color(.violet), size: .large)

        Button("Bitcoin", systemImage: "bitcoinsign.circle.fill") {
            print("Hello")
        }
        .borderedStyle(color: Color(.violet), size: .regular, hapticStyle: .rigid)

        Button("Bitcoin", systemImage: "bitcoinsign.circle.fill") {
            print("Hello")
        }
        .strokedStyle(shape: .capsule, size: .large)

        Button(systemImage: "bitcoinsign.circle.fill") {
            print("Hello")
        }
        .borderedProminentStyle(shape: .circle, color: Color(.violet), size: .large)

        Button(systemImage: "bitcoinsign.circle.fill") {
            print("Hello")
        }
        .borderedStyle(shape: .circle, color: Color(.violet), size: .large)

        Button(systemImage: "bitcoinsign.circle.fill") {
            print("Hello")
        }
        .strokedStyle(shape: .circle, size: .large)
    }
}
