//
//  RadioButton.swift
//  Apolo
//
//  Created by Eric on 19/12/24.
//

import SwiftUI

// MARK: - Radio Button Group

public struct RadioButtonGroup: View {
    private let options: [RadioOption]
    @Binding private var selectedId: String
    private let onSelect: (String) -> Void

    public init(
        options: [RadioOption],
        selectedId: Binding<String>,
        onSelect: @escaping (String) -> Void
    ) {
        self.options = options
        self._selectedId = selectedId
        self.onSelect = onSelect
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(options) { option in
                RadioButton(
                    option: option,
                    isSelected: selectedId == option.id
                ) {
                    selectedId = option.id
                    onSelect(option.id)
                }
            }
        }
    }
}

// MARK: - Radio Option

public struct RadioOption: Identifiable {
    public let id: String
    public let label: String
    public let description: String?

    public init(id: String, label: String, description: String? = nil) {
        self.id = id
        self.label = label
        self.description = description
    }
}

// MARK: - Radio Button

public struct RadioButton: View {
    // MARK: - Properties

    private let option: RadioOption
    private let isSelected: Bool
    private let action: () -> Void
    @State private var animate: Bool = false
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    init(
        option: RadioOption,
        isSelected: Bool,
        action: @escaping () -> Void
    ) {
        self.option = option
        self.isSelected = isSelected
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        HStack {
            radioCircle
            labelStack
            Spacer()
        }
        .onTapGesture {
            feedbackGenerator.impactOccurred()
            action()
        }
    }

    // MARK: - UI Components

    private var radioCircle: some View {
        ZStack {
            Circle()
                .fill(isSelected ? Color.primary : Color.clear)
                .frame(width: 10, height: 10)
            Circle()
                .stroke(Color.secondary, lineWidth: 1)
                .frame(width: 24, height: 24)
        }
        .scaleEffect(x: animate ? 0.95 : 1, y: animate ? 0.95 : 1)
        .animation(.bouncy(duration: 0.3), value: animate)
        .simultaneousGesture(pressGesture)
    }

    private var labelStack: some View {
        VStack(alignment: .leading) {
            Text(option.label)
                .body()

            if let description = option.description {
                Text(description)
                    .footnote()
                    .foregroundStyle(Color.secondary)
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
}

// MARK: - Preview

struct RadioButtonPreview: View {
    @State private var selectedId = ""

    let options = [
        RadioOption(
            id: "1",
            label: "First Option",
            description: "Bitcoin was made by Satoshi Nakamoto"
        ),
        RadioOption(
            id: "2",
            label: "Second Option",
            description: "Bitcoin was made by Satoshi Nakamoto"
        ),
        RadioOption(
            id: "3",
            label: "Third Option",
            description: "Bitcoin was made by Satoshi Nakamoto"
        )
    ]

    var body: some View {
        RadioButtonGroup(
            options: options,
            selectedId: $selectedId
        ) { newSelectedId in
            print("Selected option with id: \(newSelectedId)")
        }
        .padding()
    }
}

#Preview {
    RadioButtonPreview()
}
