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
    private let shapeStyle: AnyShapeStyle?
    private let onCheck: ((Bool) -> Void)?
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    private let titleFont: Font?
    
    public init(
        label: String? = nil,
        description: String? = nil,
        isChecked: Binding<Bool>,
        titleFont: Font? = nil,
        onCheck: ((Bool) -> Void)? = nil
    ) {
        self.label = label
        self.description = description
        self._isChecked = isChecked
        self.shapeStyle = nil
        self.titleFont = titleFont
        self.onCheck = onCheck
    }

    public init<S: ShapeStyle>(
        label: String? = nil,
        description: String? = nil,
        isChecked: Binding<Bool>,
        shapeStyle: S? = nil,
        titleFont: Font? = nil,
        onCheck: ((Bool) -> Void)? = nil
    ) {
        self.label = label
        self.description = description
        self._isChecked = isChecked
        self.shapeStyle = shapeStyle.map(AnyShapeStyle.init)
        self.titleFont = titleFont
        self.onCheck = onCheck
    }

    // MARK: - Body

    public var body: some View {
        HStack {
            checkboxSymbol
            labelStack
        }
        .contentShape(.rect)
        .gesture(tapGesture.simultaneously(with: pressGesture))
    }

    // MARK: - UI Components

    private var checkboxSymbol: some View {
        let fill: AnyShapeStyle = {
            if let style = shapeStyle {
                return isChecked ? style : AnyShapeStyle(Tokens.Color.secondarySystemFill.color)
            } else {
                return AnyShapeStyle(isChecked ? Tokens.Color.label.color : Tokens.Color.secondarySystemFill.color)
            }
        }()

        return Image(systemName: isChecked ? "checkmark.square.fill" : "square")
            .large()
            .foregroundStyle(fill)
            .scaleEffect(animate ? 0.85 : 1)
            .animation(.bouncy(duration: 0.3), value: animate)
    }

    private var labelStack: some View {
        Group {
            if let label {
                VStack(alignment: .leading) {
                    Text(label)
                        .font(titleFont ?? .abcGinto(style: .body))

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
    @Previewable @State var checked3 = true

    VStack(alignment: .leading, spacing: 16) {
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
        
        Checkbox(
            label: "ShapeStyle and titleFont",
            description: "This is a description text that explains the checkbox",
            isChecked: $checked3,
            shapeStyle: LinearGradient.init(colors: [.yellow, .orange], startPoint: .leading, endPoint: .trailing),
            titleFont: .abcGinto(style: .callout)
        ) { newValue in
            print("Checkbox tapped \(newValue)")
        }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
}
