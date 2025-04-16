//
//  Checkbox.swift
//  Apolo
//
//  Created by Eric on 19/12/24.
//

import SwiftUI

public struct Checkbox: View {
    
    // MARK: - Properties

    private var label: String?
    private var description: String?
    @Binding private var isChecked: Bool
    @State private var animate: Bool = false
    private let onCheck: ((Bool) -> Void)?
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    public init(
        label: String? = nil,
        description: String? = nil,
        isChecked: Binding<Bool>,
        onCheck: ((Bool) -> Void)? = nil
    ) {
        self.label = label
        self.description = description
        self._isChecked = isChecked
        self.onCheck = onCheck
    }

    // MARK: - Body

    public var body: some View {
        HStack {
            checkboxSymbol
            labelStack
            Spacer()
        }
        .contentShape(Rectangle())
        .gesture(tapGesture.simultaneously(with: pressGesture))
    }

    // MARK: - UI Components

    private var checkboxSymbol: some View {
        Image(systemName: isChecked ? "checkmark.square.fill" : "square")
            .large()
            .foregroundStyle(isChecked ? Tokens.Color.label.color : Tokens.Color.secondarySystemFill.color)
            .scaleEffect(animate ? 0.85 : 1)
            .animation(.bouncy(duration: 0.3), value: animate)
    }

    private var labelStack: some View {
        Group {
            if let label {
                VStack(alignment: .leading) {
                    Text(label)
                        .body()

                    if let description {
                        Text(description)
                            .footnote()
                            .foregroundStyle(Color.secondary)
                    }
                }
            }
        }
    }

    // MARK: - Gestures

    private var pressGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                animate = true
                feedbackGenerator.prepare()
            }
            .onEnded { _ in animate = false }
    }

    private var tapGesture: some Gesture {
        TapGesture()
            .onEnded {
                feedbackGenerator.impactOccurred()
                isChecked.toggle()
                onCheck?(isChecked)
        }
    }
}

// MARK: - Previews

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var checked1 = false
    @Previewable @State var checked2 = true

    VStack(spacing: 16) {
        Checkbox(label: "Default Checkbox", isChecked: $checked1) { newValue in
            print("Checkbox tapped \(newValue)")
        }

        Checkbox(
            label: "Checkbox with description",
            description: "This is a description text that explains the checkbox",
            isChecked: $checked2
        ) { newValue in
            print("Checkbox tapped \(newValue)")
        }
    }
    .padding()
}
