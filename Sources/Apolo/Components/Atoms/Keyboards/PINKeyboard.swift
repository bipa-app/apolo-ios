//
//  PINKeyboard.swift
//  Apolo
//
//  Created by Apolo on 2025.
//

import SwiftUI
import LocalAuthentication

// MARK: - PINKeyboard

public struct PINKeyboard: View {
    @Binding private var pin: String
    private let maxLength: Int
    private let showBiometric: Bool
    private let onComplete: ((String) -> Void)?
    private let onBiometricTap: (() -> Void)?

    public init(
        pin: Binding<String>,
        maxLength: Int = 6,
        showBiometric: Bool = true,
        onComplete: ((String) -> Void)? = nil,
        onBiometricTap: (() -> Void)? = nil
    ) {
        self._pin = pin
        self.maxLength = maxLength
        self.showBiometric = showBiometric
        self.onComplete = onComplete
        self.onBiometricTap = onBiometricTap
    }

    public var body: some View {
        VStack(spacing: Tokens.Spacing.extraLarge) {
            // PIN dots display
            PINDotsView(
                length: maxLength,
                filledCount: pin.count
            )

            // Keyboard
            NumericKeyboard(
                showDecimal: false,
                showBiometric: showBiometric,
                hapticStyle: .rigid
            ) { key in
                handleKeyTap(key)
            }
        }
    }

    private func handleKeyTap(_ key: KeyboardKey) {
        switch key {
        case .digit(let digit):
            guard pin.count < maxLength else { return }
            pin += "\(digit)"
            if pin.count == maxLength {
                onComplete?(pin)
            }
        case .delete:
            if !pin.isEmpty {
                pin.removeLast()
            }
        case .biometric:
            onBiometricTap?()
        default:
            break
        }
    }
}

// MARK: - PINDotsView

public struct PINDotsView: View {
    let length: Int
    let filledCount: Int
    var dotSize: CGFloat = 16
    var spacing: CGFloat = Tokens.Spacing.medium
    var filledColor: Color = Color(.label)
    var emptyColor: Color = Color(.tertiarySystemFill)

    public init(
        length: Int,
        filledCount: Int,
        dotSize: CGFloat = 16,
        spacing: CGFloat = Tokens.Spacing.medium,
        filledColor: Color = Color(.label),
        emptyColor: Color = Color(.tertiarySystemFill)
    ) {
        self.length = length
        self.filledCount = filledCount
        self.dotSize = dotSize
        self.spacing = spacing
        self.filledColor = filledColor
        self.emptyColor = emptyColor
    }

    public var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<length, id: \.self) { index in
                Circle()
                    .fill(index < filledCount ? filledColor : emptyColor)
                    .frame(width: dotSize, height: dotSize)
                    .scaleEffect(index < filledCount ? 1.0 : 0.8)
                    .animation(Tokens.Animation.bouncy, value: filledCount)
            }
        }
    }
}

// MARK: - PINInputView

public struct PINInputView: View {
    @Binding var pin: String
    let title: String
    let subtitle: String?
    let maxLength: Int
    let showBiometric: Bool
    let errorMessage: String?
    let onComplete: ((String) -> Void)?
    let onBiometricTap: (() -> Void)?

    @State private var shake = false

    public init(
        pin: Binding<String>,
        title: String,
        subtitle: String? = nil,
        maxLength: Int = 6,
        showBiometric: Bool = true,
        errorMessage: String? = nil,
        onComplete: ((String) -> Void)? = nil,
        onBiometricTap: (() -> Void)? = nil
    ) {
        self._pin = pin
        self.title = title
        self.subtitle = subtitle
        self.maxLength = maxLength
        self.showBiometric = showBiometric
        self.errorMessage = errorMessage
        self.onComplete = onComplete
        self.onBiometricTap = onBiometricTap
    }

    public var body: some View {
        VStack(spacing: Tokens.Spacing.extraLarge) {
            Spacer()

            // Header
            VStack(spacing: Tokens.Spacing.extraSmall) {
                Text(title)
                    .font(.abcGinto(style: .title2, weight: .bold))
                    .foregroundStyle(Color(.label))

                if let subtitle {
                    Text(subtitle)
                        .font(.abcGinto(style: .subheadline, weight: .regular))
                        .foregroundStyle(Color(.secondaryLabel))
                }
            }

            // PIN dots
            PINDotsView(
                length: maxLength,
                filledCount: pin.count,
                filledColor: errorMessage != nil ? Color(.systemRed) : Color(.label)
            )
            .modifier(ShakeEffect(animatableData: shake ? 1 : 0))
            .onChange(of: errorMessage) { newValue in
                if newValue != nil {
                    withAnimation(.default.repeatCount(3, autoreverses: true).speed(6)) {
                        shake = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        shake = false
                    }
                }
            }

            // Error message
            if let errorMessage {
                Text(errorMessage)
                    .font(.abcGinto(style: .footnote, weight: .medium))
                    .foregroundStyle(Color(.systemRed))
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }

            Spacer()

            // Keyboard
            NumericKeyboard(
                showDecimal: false,
                showBiometric: showBiometric,
                hapticStyle: .rigid
            ) { key in
                handleKeyTap(key)
            }
            .padding(.bottom, Tokens.Spacing.large)
        }
        .padding(.horizontal, Tokens.Spacing.large)
    }

    private func handleKeyTap(_ key: KeyboardKey) {
        switch key {
        case .digit(let digit):
            guard pin.count < maxLength else { return }
            pin += "\(digit)"
            if pin.count == maxLength {
                onComplete?(pin)
            }
        case .delete:
            if !pin.isEmpty {
                pin.removeLast()
            }
        case .biometric:
            onBiometricTap?()
        default:
            break
        }
    }
}

// MARK: - ShakeEffect

private struct ShakeEffect: GeometryEffect {
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        let offset = sin(animatableData * .pi * 4) * 10
        return ProjectionTransform(CGAffineTransform(translationX: offset, y: 0))
    }
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview("PIN Keyboard") {
    @Previewable @State var pin = ""

    PINKeyboard(
        pin: $pin,
        maxLength: 6,
        showBiometric: true
    ) { completedPin in
        print("PIN entered: \(completedPin)")
    } onBiometricTap: {
        print("Biometric tapped")
    }
    .padding()
}

@available(iOS 17.0, *)
#Preview("PIN Input View") {
    @Previewable @State var pin = ""
    @Previewable @State var error: String? = nil

    PINInputView(
        pin: $pin,
        title: "Enter your PIN",
        subtitle: "Enter your 6-digit PIN to continue",
        maxLength: 6,
        showBiometric: true,
        errorMessage: error,
        onComplete: { completedPin in
            if completedPin == "123456" {
                print("Success!")
            } else {
                error = "Incorrect PIN"
                pin = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    error = nil
                }
            }
        },
        onBiometricTap: {
            print("Biometric tapped")
        }
    )
}
