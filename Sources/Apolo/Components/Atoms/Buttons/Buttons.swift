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

@available(iOS 26.0, *)
public struct ProminentButtonGlassModifier: ViewModifier {
    @Environment(\.isEnabled) private var isEnabled

    public func body(content: Content) -> some View {
        if isEnabled {
            content
                .buttonStyle(.glassProminent)
        } else {
            content
                .buttonStyle(.borderedProminent)
        }
    }
}

public extension View {
    func borderedProminentStyle(
        shape: CustomButtonShape = .capsule,
        color: Color = .green,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft,
        preventDoubleTap: Bool = true,
        glassEnabled: Bool = true
    ) -> some View {
        if glassEnabled {
            return AnyView(self.borderedProminentStyle(shape, color, size, hapticStyle, preventDoubleTap))
        } else {
            return AnyView(self.borderedProminentStyleNoGlass(shape, color, size, hapticStyle, preventDoubleTap))
        }
    }
    
    func borderedProminentStyle(
        _ shape: CustomButtonShape,
        _ color: Color,
        _ size: ControlSize,
        _ hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle,
        _ preventDoubleTap: Bool
    ) -> some View {
        if #available(iOS 26.0, *) {
            return modifier(ProminentButtonGlassModifier())
                .controlSize(size)
                .modifier(ButtonShapeModifier(shape: shape))
                .tint(color)
                .font(.abcGinto(style: .body, weight: .regular))
                .modifier(HapticFeedbackModifier(style: hapticStyle))
                .preventDoubleTap(enabled: preventDoubleTap)
        } else {
            return buttonStyle(.borderedProminent)
                .controlSize(size)
                .modifier(ButtonShapeModifier(shape: shape))
                .tint(color)
                .font(.abcGinto(style: .body, weight: .regular))
                .modifier(HapticFeedbackModifier(style: hapticStyle))
                .preventDoubleTap(enabled: preventDoubleTap)
        }
    }
    
    func borderedProminentStyleNoGlass(
        _ shape: CustomButtonShape,
        _ color: Color,
        _ size: ControlSize,
        _ hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle,
        _ preventDoubleTap: Bool
    ) -> some View {
        return buttonStyle(.borderedProminent)
            .controlSize(size)
            .modifier(ButtonShapeModifier(shape: shape))
            .tint(color)
            .font(.abcGinto(style: .body, weight: .regular))
            .modifier(HapticFeedbackModifier(style: hapticStyle))
            .preventDoubleTap(enabled: preventDoubleTap)
    }
    
    func borderedProminentStyle<S: ShapeStyle>(
        shape: CustomButtonShape = .capsule,
        shapeStyle: S,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft,
        preventDoubleTap: Bool = true
    ) -> some View {
        borderedProminentStyle(shape, shapeStyle, size, hapticStyle, preventDoubleTap)
    }
    
    func borderedProminentStyle<S: ShapeStyle>(
        _ shape: CustomButtonShape,
        _ shapeStyle: S,
        _ size: ControlSize,
        _ hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle,
        _ preventDoubleTap: Bool
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
            .preventDoubleTap(enabled: preventDoubleTap)
    }

    func borderedStyle(
        shape: CustomButtonShape = .capsule,
        color: Color = .green,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft,
        preventDoubleTap: Bool = true,
        glassEnabled: Bool = true,
        isClear: Bool = false
    ) -> some View {
        if glassEnabled {
            return AnyView(borderedStyle(shape, color, size, hapticStyle, preventDoubleTap, isClear))
        } else {
            return AnyView(borderedStyleNoGlass(shape, color, size, hapticStyle, preventDoubleTap))
        }
    }
    
    func borderedStyle(
        _ shape: CustomButtonShape,
        _ color: Color,
        _ size: ControlSize,
        _ hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle,
        _ preventDoubleTap: Bool,
        _ isClear: Bool
    ) -> some View {
        if #available(iOS 26.0, *) {
            return buttonStyle(.bordered)
                .controlSize(size)
                .modifier(ButtonShapeModifier(shape: shape))
                .tint(color)
                .foregroundStyle(color)
                .font(.abcGinto(style: .body, weight: .regular))
                .modifier(HapticFeedbackModifier(style: hapticStyle))
                .preventDoubleTap(enabled: preventDoubleTap)
                .glassEffect(isClear ? .clear.interactive() : .regular.interactive(), in: shape.toViewShape)
        } else {
            return buttonStyle(.bordered)
                .controlSize(size)
                .modifier(ButtonShapeModifier(shape: shape))
                .tint(color)
                .font(.abcGinto(style: .body, weight: .regular))
                .modifier(HapticFeedbackModifier(style: hapticStyle))
                .preventDoubleTap(enabled: preventDoubleTap)
        }
    }
    
    func borderedStyleNoGlass(
        _ shape: CustomButtonShape,
        _ color: Color,
        _ size: ControlSize,
        _ hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle,
        _ preventDoubleTap: Bool
    ) -> some View {
        return buttonStyle(.bordered)
            .controlSize(size)
            .modifier(ButtonShapeModifier(shape: shape))
            .tint(color)
            .font(.abcGinto(style: .body, weight: .regular))
            .modifier(HapticFeedbackModifier(style: hapticStyle))
            .preventDoubleTap(enabled: preventDoubleTap)
    }

    func plainStyle(
        shape: CustomButtonShape = .capsule,
        color: Color = .green,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft,
        preventDoubleTap: Bool = true
    ) -> some View {
        plainStyle(shape, color, size, hapticStyle, preventDoubleTap)
    }
    
    func plainStyle(
        _ shape: CustomButtonShape,
        _ color: Color,
        _ size: ControlSize,
        _ hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle,
        _ preventDoubleTap: Bool
    ) -> some View {
        buttonStyle(.plain)
            .controlSize(size)
            .modifier(ButtonShapeModifier(shape: shape))
            .tint(color)
            .font(.abcGinto(style: .body, weight: .regular))
            .modifier(HapticFeedbackModifier(style: hapticStyle))
            .preventDoubleTap(enabled: preventDoubleTap)
    }

    func strokedStyle(
        shape: CustomButtonShape = .capsule,
        tintColor: Color = .primary,
        borderColor: Color = .primary,
        backgroundColor: Color = .clear,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft,
        preventDoubleTap: Bool = true,
        isGlassEnabled: Bool = true,
        isGlassClear: Bool = true
    ) -> some View {
        strokedStyle(
            shape,
            tintColor,
            borderColor,
            backgroundColor,
            size,
            hapticStyle,
            preventDoubleTap,
            isGlassEnabled,
            isGlassClear
        )
    }
    
    func strokedStyle(
        _ shape: CustomButtonShape,
        _ tintColor: Color,
        _ borderColor: Color,
        _ backgroundColor: Color,
        _ size: ControlSize,
        _ hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle,
        _ preventDoubleTap: Bool,
        _ isGlassEnabled: Bool,
        _ isGlassClear: Bool
    ) -> some View {
        modifier(
            StrokedButtonModifier(
                shape: shape,
                tintColor: tintColor,
                borderColor: borderColor,
                size: size,
                backgroundColor: backgroundColor,
                isGlassEnabled: isGlassEnabled,
                isGlassClear: isGlassClear
            )
        )
        .font(.abcGinto(style: .subheadline, weight: .regular))
        .modifier(HapticFeedbackModifier(style: hapticStyle))
        .preventDoubleTap(enabled: preventDoubleTap)
    }
}

// MARK: - Button

public extension Button {
    func borderedProminentStyle(
        shape: CustomButtonShape = .capsule,
        color: Color = .green,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft,
        preventDoubleTap: Bool = true,
        glassEnabled: Bool = true
    ) -> some View {
        if glassEnabled {
            return AnyView(self.borderedProminentStyle(shape, color, size, hapticStyle, preventDoubleTap))
        } else {
            return AnyView(self.borderedProminentStyleNoGlass(shape, color, size, hapticStyle, preventDoubleTap))
        }
    }
    
    func borderedProminentStyle<S: ShapeStyle>(
        shape: CustomButtonShape = .capsule,
        shapeStyle: S,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft,
        preventDoubleTap: Bool = true
    ) -> some View {
        borderedProminentStyle(shape, shapeStyle, size, hapticStyle, preventDoubleTap)
    }

    func borderedStyle(
        shape: CustomButtonShape = .capsule,
        color: Color = .green,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft,
        preventDoubleTap: Bool = true,
        glassEnabled: Bool = true,
        isClear: Bool = false
    ) -> some View {
        if glassEnabled {
            return AnyView(borderedStyle(shape, color, size, hapticStyle, preventDoubleTap, isClear))
        } else {
            return AnyView(borderedStyleNoGlass(shape, color, size, hapticStyle, preventDoubleTap))
        }
    }

    func plainStyle(
        shape: CustomButtonShape = .capsule,
        color: Color = .green,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft,
        preventDoubleTap: Bool = true
    ) -> some View {
        plainStyle(shape, color, size, hapticStyle, preventDoubleTap)
    }

    func strokedStyle(
        shape: CustomButtonShape = .capsule,
        tintColor: Color = .primary,
        borderColor: Color = .primary,
        backgroundColor: Color = .clear,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft,
        preventDoubleTap: Bool = true,
        isGlassEnabled: Bool = true,
        isGlassClear: Bool = true
    ) -> some View {
        strokedStyle(
            shape,
            tintColor,
            borderColor,
            backgroundColor,
            size,
            hapticStyle,
            preventDoubleTap,
            isGlassEnabled,
            isGlassClear
        )
    }
}

// MARK: - ShareLink

public extension ShareLink {
    func borderedProminentStyle(
        shape: CustomButtonShape = .capsule,
        color: Color = .green,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft,
        preventDoubleTap: Bool = true
    ) -> some View {
        borderedProminentStyle(shape, color, size, hapticStyle, preventDoubleTap)
    }

    func borderedStyle(
        shape: CustomButtonShape = .capsule,
        color: Color = .green,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft,
        preventDoubleTap: Bool = true,
        isClear: Bool = false
    ) -> some View {
        borderedStyle(shape, color, size, hapticStyle, preventDoubleTap, isClear)
    }

    func plainStyle(
        shape: CustomButtonShape = .capsule,
        color: Color = .green,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft,
        preventDoubleTap: Bool = true
    ) -> some View {
        plainStyle(shape, color, size, hapticStyle, preventDoubleTap)
    }

    func strokedStyle(
        shape: CustomButtonShape = .capsule,
        tintColor: Color = .primary,
        borderColor: Color = .primary,
        backgroundColor: Color = .clear,
        size: ControlSize = .large,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft,
        preventDoubleTap: Bool = true,
        isGlassEnabled: Bool = true,
        isGlassClear: Bool = true
    ) -> some View {
        strokedStyle(
            shape,
            tintColor,
            borderColor,
            backgroundColor,
            size,
            hapticStyle,
            preventDoubleTap,
            isGlassEnabled,
            isGlassClear
        )
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
    
    let enabled: Bool
    @State private var allowTap = true

    public func body(content: Content) -> some View {
        if enabled {
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
        } else {
            content
        }
    }
}

public extension View {
    func preventDoubleTap(enabled: Bool = true) -> some View {
        modifier(PreventDoubleTapModifier(enabled: enabled))
    }
}

// MARK: - StrokedButtonModifier

public struct StrokedButtonModifier: ViewModifier {
    public let shape: CustomButtonShape
    public let tintColor: Color
    public let borderColor: Color
    public let size: ControlSize
    public let backgroundColor: Color
    public let isGlassEnabled: Bool
    public let isGlassClear: Bool

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
            .background(
                Group {
                    switch self.shape {
                    case .capsule:
                        Capsule()
                            .strokeBorder(borderColor.opacity(0.15), lineWidth: 1.5)
                            .background {
                                backgroundColor
                                    .clipShape(Capsule())
                            }
                    case .circle:
                        Circle()
                            .strokeBorder(borderColor.opacity(0.15), lineWidth: 1.5)
                            .background {
                                backgroundColor
                                    .clipShape(Circle())
                            }
                    case .roundedRectangle:
                        RoundedRectangle(cornerRadius: Tokens.CornerRadius.small)
                            .strokeBorder(borderColor.opacity(0.15), lineWidth: 1.5)
                            .background {
                                backgroundColor
                                    .clipShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.small))
                            }
                    }
                }
            )
            .if(condition: { isGlassEnabled }) { view in
                view
                    .modifier(
                        GlassEffectModifierShape(
                            color: nil,
                            shape: shape.toViewShape,
                            isClear: isGlassClear
                        )
                    )
            }
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

// MARK: - Glass


public struct GlassEffectModifierShape<S: Shape>: ViewModifier {
    var color: Color?
    var shape: S?
    var isClear: Bool

    init(color: Color? = nil, shape: S? = nil, isClear: Bool) {
        self.color = color
        self.shape = shape
        self.isClear = isClear
    }

    @ViewBuilder
    public func body(content: Content) -> some View {
        if #available(iOS 26.0, *), let shape {
            content
                .glassEffect(isClear ? .clear.tint(color).interactive() : .regular.tint(color).interactive(), in: shape)
        } else {
            content
        }
    }
}

public struct GlassEffectModifier: ViewModifier {
    var color: Color?
    var isClear: Bool

    @ViewBuilder
    public func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffect(isClear ? .clear.tint(color).interactive() : .regular.tint(color).interactive())
        } else {
            content
        }
    }
}

public extension View {
    func glassEffectIfAvailable<T, S: Shape>(color: Color?, isClear: Bool, shape: S?, orElse: (Self) -> T) -> some View where T : View {
        self
            .if(condition: {
                if #available(iOS 26.0, *) {
                    return false
                } else {
                    return true
                }
            }, transform: orElse)
            .modifier(GlassEffectModifierShape(color: color, shape: shape, isClear: isClear))
    }
    
    func glassEffectIfAvailable<T>(color: Color?, isClear: Bool, orElse: (Self) -> T) -> some View where T : View {
        self
            .if(condition: {
                if #available(iOS 26.0, *) {
                    if color == .clear {
                        return true
                    } else {
                        return false
                    }
                } else {
                    return true
                }
            }, transform: orElse)
            .modifier(GlassEffectModifier(color: color, isClear: isClear))
    }
    
    func glassEffectIfAvailable<S: Shape>(color: Color?, shape: S?, isClear: Bool) -> some View {
        modifier(GlassEffectModifierShape(color: color, shape: shape, isClear: isClear))
    }
    
    func glassEffectIfAvailable(color: Color?, isClear: Bool) -> some View {
        modifier(GlassEffectModifier(color: color, isClear: isClear))
    }
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var isEnabled = false
    
    ScrollView {
        VStack(spacing: 20) {
            Button("Bitcoin", systemImage: "bitcoinsign.circle.fill") {
                print("Hello")
            }
            .borderedProminentStyle(color: Color(.violet), size: .large)
            
            Button {
            } label: {
                Text("Prosseguir")
                    .body()
                    .foregroundStyle(isEnabled ? Tokens.Color.systemBackground.color : Tokens.Color.tertiaryLabel.color)
                    .frame(maxWidth: .infinity)
            }
            .borderedProminentStyle(color: .primary)
            .disabled(!isEnabled)

            Button(".borderedProminentStyle") {
                print("borderedProminentStyle")
                isEnabled.toggle()
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
            .strokedStyle(shape: .capsule, size: .large, isGlassEnabled: true)
            
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
            
            Button(systemImage: "dollarsign.circle.fill") {
                print("Hello")
            }
            .strokedStyle(shape: .circle, backgroundColor: .mint, size: .large)

            Button(action: {
                print("strokedStyle")
            }, label: {
                Text("Stroked with background")
                    .foregroundStyle(.black)
            })
            .strokedStyle(shape: .capsule, backgroundColor: .white, size: .large)

            Button(action: {
                print("strokedStyle")
            }, label: {
                Text(".strokedStyle glass enabled")
                    .foregroundStyle(.orange)
            })
            .strokedStyle(shape: .capsule, borderColor: .orange, size: .large, isGlassClear: false)
            
            Button(action: {
                print("strokedStyle")
            }, label: {
                Text(".strokedStyle glass disabled")
                    .foregroundStyle(.orange)
            })
            .strokedStyle(shape: .capsule, borderColor: .orange, size: .large, isGlassEnabled: false)
            
            ShareLink(item: "Share me") {
                Text("Compartilhar")
            }
            .plainStyle()
            
            ShareLink(item: "Share me") {
                Text("Compartilhar")
            }
            .borderedProminentStyle()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .background {
        Color(.quaternarySystemFill)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
    }
}
