//
//  Checkbox.swift
//  Apolo
//
//  Created by Eric on 19/12/24.
//

import SwiftUI

public struct Checkbox: View {
    // MARK: - Properties

    public var label: String?
    public var description: String?
    public var isActive: Bool
    @State private var isPressed: Bool = false

    public init(label: String? = nil, description: String? = nil, isChecked: Bool) {
        self.label = label
        self.description = description
        self.isActive = isChecked
    }

    // MARK: - Body

    public var body: some View {
        HStack {
            checkboxSymbol
            labelStack
            Spacer()
        }
    }

    // MARK: - UI Components

    private var checkboxSymbol: some View {
        Image(systemName: isActive ? "checkmark.square.fill" : "square")
            .font(.system(size: 20))
            .foregroundStyle(isActive ? Color.primary : Color.secondary)
            .scaleEffect(isPressed ? 0.95 : 1)
            .animation(.bouncy(duration: 0.3), value: isPressed)
            .simultaneousGesture(pressGesture)
    }

    private var labelStack: some View {
        Group {
            if let label = label {
                VStack(alignment: .leading) {
                    Text(label)
                        .body()

                    if let description = description {
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
            .onChanged { _ in isPressed = true }
            .onEnded { _ in isPressed = false }
    }
}

#Preview {
    VStack(spacing: 16) {
        Checkbox(label: "Default Checkbox", isChecked: false)
        Checkbox(
            label: "Checkbox with description",
            description: "This is a description text that explains the checkbox",
            isChecked: true
        )
    }
    .padding()
}
