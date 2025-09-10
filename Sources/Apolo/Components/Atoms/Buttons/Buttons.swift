//
//  Buttons.swift
//  Apolo
//
//  Created by Eric on 09/12/24.
//

import SwiftUI

// MARK: CustomButtonShape

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

// MARK: - View

private extension View {
    func borderedProminentStyle(
        _ shape: CustomButtonShape,
        _ color: Color,
        _ size: ControlSize,
        _ hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle
    ) -> some View {
        buttonStyle(.borderedProminent)
            .controlSize(size)
            .modifier(ButtonShapeModifier(shape: shape))
            .tint(color)
            .font(.abcGinto(style: .body, weight: .regular))
            .modifier(HapticFeedbackModifier(style: hapticStyle))
            .preventDoubleTap()
    }
    
    func borderedProminentStyle<S: ShapeStyle>(
        _ shape: CustomButtonShape,
        _ shapeStyle: S,
        _ size: ControlSize,
        _ hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle
    ) -> some View {
        buttonStyle(.borderedProminent)
            .controlSize(size)
            .modifier(ButtonShapeModifier(shape: shape))
            .tint(.clear)
            .font(.abcGinto(style: .body, weight: .regular))
            .background(
                shape.toViewShape
                    .fill(shapeStyle)
            )
            .modifier(HapticFeedbackModifier(style: hapticStyle))
            .preventDoubleTap()
    }

    func borderedStyle(
        _ shape: CustomButtonShape,
        _ color: Color,
        _ size: ControlSize,
        _ hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle
    ) -> some View {
        buttonStyle(.bordered)
            .controlSize(size)
            .modifier(ButtonShapeModifier(shape: shape))
            .tint(color)
            .font(.abcGinto(style: .body, weight: .regular))
            .modifier(HapticFeedbackModifier(style: hapticStyle))
            .preventDoubleTap()
    }

    func plainStyle(
        _ shape: CustomButtonShape,
        _ color: Color,
        _ size: ControlSize,
        _ hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle
    ) -> some View {
        buttonStyle(.plain)
            .controlSize(size)
            .modifier(ButtonShapeModifier(shape: shape))
            .tint(color)
            .font(.abcGinto(style: .body, weight: .regular))
            .modifier(HapticFeedbackModifier(style: hapticStyle))
            .preventDoubleTap()
    }

    func strokedStyle(
        _ shape: CustomButtonShape,
        _ tintColor: Color,
        _ borderColor: Color,
        _ size: ControlSize,
        _ hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle
    ) -> some View {
        modifier(
            StrokedButtonModifier(
                shape: shape,
                tintColor: tintColor,
                borderColor: borderColor,
                size: size
            )
        )
        .font(.abcGinto(style: .subheadline, weight: .regular))
        .modifier(HapticFeedbackModifier(style: hapticStyle))
        .preventDoubleTap()
    }
}

// MARK: - Button

public extension Button {
    func borderedProminentStyle(
        shape: CustomButtonShape = .capsule,
        color: Color = .green,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft
    ) -> some View {
        borderedProminentStyle(shape, color, size, hapticStyle)
    }
    
    func borderedProminentStyle<S: ShapeStyle>(
        shape: CustomButtonShape = .capsule,
        shapeStyle: S,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft
    ) -> some View {
        borderedProminentStyle(shape, shapeStyle, size, hapticStyle)
    }

    func borderedStyle(
        shape: CustomButtonShape = .capsule,
        color: Color = .green,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft
    ) -> some View {
        borderedStyle(shape, color, size, hapticStyle)
    }

    func plainStyle(
        shape: CustomButtonShape = .capsule,
        color: Color = .green,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft
    ) -> some View {
        plainStyle(shape, color, size, hapticStyle)
    }

    func strokedStyle(
        shape: CustomButtonShape = .capsule,
        tintColor: Color = .primary,
        borderColor: Color = .primary,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft
    ) -> some View {
        strokedStyle(shape, tintColor, borderColor, size, hapticStyle)
    }
}

// MARK: - ShareLink

public extension ShareLink {
    func borderedProminentStyle(
        shape: CustomButtonShape = .capsule,
        color: Color = .green,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft
    ) -> some View {
        borderedProminentStyle(shape, color, size, hapticStyle)
    }

    func borderedStyle(
        shape: CustomButtonShape = .capsule,
        color: Color = .green,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft
    ) -> some View {
        borderedStyle(shape, color, size, hapticStyle)
    }

    func plainStyle(
        shape: CustomButtonShape = .capsule,
        color: Color = .green,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft
    ) -> some View {
        plainStyle(shape, color, size, hapticStyle)
    }

    func strokedStyle(
        shape: CustomButtonShape = .capsule,
        tintColor: Color = .primary,
        borderColor: Color = .primary,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft
    ) -> some View {
        strokedStyle(shape, tintColor, borderColor, size, hapticStyle)
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

// MARK: - ButtonShapeModifier

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

// MARK: - PreventDoubleTapModifier

public struct PreventDoubleTapModifier: ViewModifier {
    @State private var allowTap = true

    public func body(content: Content) -> some View {
        content
            .allowsHitTesting(allowTap)
            .simultaneousGesture(
                TapGesture()
                    .onEnded {
                        guard allowTap else { return }
                        allowTap.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            allowTap.toggle()
                        }
                    }
            )
    }
}

public extension View {
    func preventDoubleTap() -> some View {
        modifier(PreventDoubleTapModifier())
    }
}

// MARK: - StrokedButtonModifier

public struct StrokedButtonModifier: ViewModifier {
    public let shape: CustomButtonShape
    public let tintColor: Color
    public let borderColor: Color
    public let size: ControlSize

    @Environment(\.isEnabled) private var isEnabled

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
            .controlSize(size)
            .tint(tintColor)
            .padding(.vertical, Tokens.Spacing.small)
            .padding(.horizontal, sizes.padding)
            .frame(minHeight: sizes.height)
            .overlay(
                Group {
                    switch self.shape {
                    case .capsule:
                        Capsule()
                            .strokeBorder(borderColor.opacity(0.15), lineWidth: 1)
                    case .circle:
                        Circle()
                            .strokeBorder(borderColor.opacity(0.15), lineWidth: 1)
                    case .roundedRectangle:
                        RoundedRectangle(cornerRadius: Tokens.CornerRadius.small)
                            .strokeBorder(borderColor.opacity(0.15), lineWidth: 1)
                    }
                }
            )
            .opacity(isEnabled ? 1.0 : 0.5)
    }
}

// MARK: - HapticFeedbackModifier

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

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(spacing: 20) {
            Button("Bitcoin", systemImage: "bitcoinsign.circle.fill") {
                print("Hello")
            }
            .borderedProminentStyle(color: Color(.violet), size: .large)
            
            
            Button(".borderedProminentStyle") {
                print("borderedProminentStyle")
            }
            .borderedProminentStyle(
                shapeStyle: LinearGradient(
                    colors: [.yellow, .red],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                size: .large
            )
            .foregroundStyle(.white)
            
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
            
            Button(action: {
                print("strokedStyle")
            }, label: {
                Text(".strokedStyle")
                    .foregroundStyle(.orange)
            })
            .strokedStyle(shape: .capsule, borderColor: .orange, size: .large)
            
            ShareLink(item: "Share me") {
                Text("Compartilhar")
            }
            .plainStyle()
            
            ShareLink(item: "Share me") {
                Text("Compartilhar")
            }
            .borderedProminentStyle()
        }
    }
}
