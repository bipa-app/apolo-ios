//
//  NumericKeyboard.swift
//  Apolo
//
//  Created by Apolo on 2025.
//

import SwiftUI

// MARK: - KeyboardKey

public enum KeyboardKey: Hashable {
    case digit(Int)
    case decimal
    case delete
    case biometric
    case empty

    var displayValue: String {
        switch self {
        case .digit(let value): return "\(value)"
        case .decimal: return ","
        case .delete: return ""
        case .biometric: return ""
        case .empty: return ""
        }
    }

    var systemImage: String? {
        switch self {
        case .delete: return "delete.left.fill"
        case .biometric: return "faceid"
        default: return nil
        }
    }
}

// MARK: - NumericKeyboard

public struct NumericKeyboard: View {
    private let onKeyTap: (KeyboardKey) -> Void
    private let showDecimal: Bool
    private let showBiometric: Bool
    private let hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle

    public init(
        showDecimal: Bool = false,
        showBiometric: Bool = false,
        hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .light,
        onKeyTap: @escaping (KeyboardKey) -> Void
    ) {
        self.showDecimal = showDecimal
        self.showBiometric = showBiometric
        self.hapticStyle = hapticStyle
        self.onKeyTap = onKeyTap
    }

    private var keys: [[KeyboardKey]] {
        [
            [.digit(1), .digit(2), .digit(3)],
            [.digit(4), .digit(5), .digit(6)],
            [.digit(7), .digit(8), .digit(9)],
            [
                showBiometric ? .biometric : (showDecimal ? .decimal : .empty),
                .digit(0),
                .delete
            ]
        ]
    }

    public var body: some View {
        VStack(spacing: Tokens.Spacing.small) {
            ForEach(keys, id: \.self) { row in
                HStack(spacing: Tokens.Spacing.small) {
                    ForEach(row, id: \.self) { key in
                        KeyboardButton(
                            key: key,
                            hapticStyle: hapticStyle,
                            onTap: { onKeyTap(key) }
                        )
                    }
                }
            }
        }
    }
}

// MARK: - KeyboardButton

private struct KeyboardButton: View {
    let key: KeyboardKey
    let hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle
    let onTap: () -> Void

    @State private var isPressed = false

    private var isInteractive: Bool {
        switch key {
        case .empty: return false
        default: return true
        }
    }

    var body: some View {
        Button {
            guard isInteractive else { return }
            let impact = UIImpactFeedbackGenerator(style: hapticStyle)
            impact.impactOccurred()
            onTap()
        } label: {
            Group {
                if let systemImage = key.systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: 22, weight: .medium))
                } else {
                    Text(key.displayValue)
                        .font(.abcGinto(size: 28, weight: .medium))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .foregroundStyle(isInteractive ? Color(.label) : .clear)
            .background(
                isInteractive
                    ? (isPressed ? Color(.systemFill) : Color(.secondarySystemFill))
                    : .clear
            )
            .clipShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.small))
        }
        .buttonStyle(.plain)
        .disabled(!isInteractive)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var value = ""

    return VStack(spacing: Tokens.Spacing.extraLarge) {
        Text(value.isEmpty ? "0" : value)
            .font(.abcGinto(size: 48, weight: .bold))
            .frame(maxWidth: .infinity)
            .padding()

        NumericKeyboard(showDecimal: true) { key in
            switch key {
            case .digit(let digit):
                value += "\(digit)"
            case .decimal:
                if !value.contains(",") {
                    value += value.isEmpty ? "0," : ","
                }
            case .delete:
                if !value.isEmpty {
                    value.removeLast()
                }
            default:
                break
            }
        }
    }
    .padding()
}
