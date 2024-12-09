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

        HStack {
            Button("Bitcoin", systemImage: "bitcoinsign.circle.fill") {
                print("Hello")
            }
            .borderedProminent(shape: .circle, color: Color(.violet), size: .large)

            Button("Bitcoin", systemImage: "bitcoinsign.circle.fill") {
                print("Hello")
            }
            .bordered(shape: .circle, color: Color(.violet), size: .large)
        }

        Button("Bitcoin", systemImage: "bitcoinsign.circle.fill") {
            print("Hello")
        }
        .bordered(color: Color(.violet), size: .large)
        .disabled(true)
    }
}
