//
//  Buttons.swift
//  Apolo
//
//  Created by Eric on 09/12/24.
//

import SwiftUI

enum CustomButtonShape {
    case capsule
    case circle
    case roundedRectangle

    @available(iOS 17.0, *)
    var toButtonBorderShape: ButtonBorderShape {
        switch self {
        case .capsule:
            return .capsule
        case .circle:
            return .circle
        case .roundedRectangle:
            return .roundedRectangle
        }
    }

    var toViewShape: AnyShape {
        switch self {
        case .capsule:
            return AnyShape(Capsule())
        case .circle:
            return AnyShape(Circle())
        case .roundedRectangle:
            return AnyShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.small))
        }
    }

    var toStrokeShape: AnyShape {
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

extension Button {
    func borderedProminent(
        shape: CustomButtonShape = .capsule,
        color: Color = .green,
        size: ControlSize = .regular
    ) -> some View {
        self
            .buttonStyle(.borderedProminent)
            .controlSize(size)
            .modifier(ButtonShapeModifier(shape: shape))
            .tint(color)
            .font(.abcGinto(style: .subheadline, weight: .regular))
    }

    func bordered(
        shape: CustomButtonShape = .capsule,
        color: Color = .green,
        size: ControlSize = .regular
    ) -> some View {
        self
            .buttonStyle(.bordered)
            .controlSize(size)
            .modifier(ButtonShapeModifier(shape: shape))
            .tint(color)
            .font(.abcGinto(style: .subheadline, weight: .regular))
    }

    func plain(
        shape: CustomButtonShape = .capsule,
        color: Color = .green,
        size: ControlSize = .regular
    ) -> some View {
        self
            .buttonStyle(.plain)
            .controlSize(size)
            .modifier(ButtonShapeModifier(shape: shape))
            .tint(color)
            .font(.abcGinto(style: .subheadline, weight: .regular))
    }

    func stroked(
        shape: CustomButtonShape = .capsule,
        color: Color = .primary,
        size: ControlSize = .regular
    ) -> some View {
        self
            .modifier(StrokedButtonModifier(shape: shape, size: size, color: color))
            .font(.abcGinto(style: .subheadline, weight: .regular))
    }
}

/// Extension to allow the creation of buttons with system images only
extension Button {
    init(systemImage: String, action: @escaping () -> Void) where Label == Image {
        self.init(action: action) {
            Image(systemName: systemImage)
        }
    }
}

struct ButtonShapeModifier: ViewModifier {
    let shape: CustomButtonShape

    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.buttonBorderShape(shape.toButtonBorderShape)
        } else {
            content.clipShape(self.shape.toViewShape)
        }
    }
}

struct StrokedButtonModifier: ViewModifier {
    let shape: CustomButtonShape
    let size: ControlSize
    let color: Color

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

    func body(content: Content) -> some View {
        let sizes = self.sizeValues(for: self.size)

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
                            .strokeBorder(self.color.opacity(0.3), lineWidth: 1)
                    case .circle:
                        Circle()
                            .strokeBorder(self.color.opacity(0.3), lineWidth: 1)
                    case .roundedRectangle:
                        RoundedRectangle(cornerRadius: Tokens.CornerRadius.small)
                            .strokeBorder(self.color.opacity(0.3), lineWidth: 1)
                    }
                }
            )
            .opacity(self.isEnabled ? 1.0 : 0.5)
    }
}

#Preview {
    VStack(spacing: 12) {
        Button("Bitcoin", systemImage: "bitcoinsign.circle.fill") {
            print("Hello")
        }
        .borderedProminent(color: Color(.violet), size: .large)

        Button("Bitcoin", systemImage: "bitcoinsign.circle.fill") {
            print("Hello")
        }
        .bordered(color: Color(.violet), size: .large)

        Button("Bitcoin", systemImage: "bitcoinsign.circle.fill") {
            print("Hello")
        }
        .stroked(shape: .capsule, size: .large)

        Button(systemImage: "bitcoinsign.circle.fill") {
            print("Hello")
        }
        .borderedProminent(shape: .circle, color: Color(.violet), size: .large)

        Button(systemImage: "bitcoinsign.circle.fill") {
            print("Hello")
        }
        .bordered(shape: .circle, color: Color(.violet), size: .large)

        Button(systemImage: "bitcoinsign.circle.fill") {
            print("Hello")
        }
        .stroked(shape: .circle, size: .large)
    }
}
