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
            if let shapeStyle {
                return isChecked ? shapeStyle : AnyShapeStyle(Tokens.Color.secondarySystemFill.color)
            } else {
                return AnyShapeStyle(isChecked ? Tokens.Color.label.color : Tokens.Color.secondarySystemFill.color)
            }
        }()

        if #available(iOS 18.0, *) {
            return Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                .large()
                .foregroundStyle(fill)
                .scaleEffect(animate ? 0.85 : 1)
                .animation(.bouncy(duration: 0.3), value: animate)
                .contentTransition(
                    .symbolEffect(
                        .replace.magic(fallback: .downUp.byLayer),
                        options: .nonRepeating
                    )
                )
        } else {
            return Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                .large()
                .foregroundStyle(fill)
                .scaleEffect(animate ? 0.85 : 1)
                .animation(.bouncy(duration: 0.3), value: animate)
                .transition(.opacity)
        }
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

// MARK: - Toogle Modifier

public struct ToggleCheckboxStyle: ToggleStyle {
    @State private var animate: Bool = false
    private let shapeStyle: AnyShapeStyle?

    public init(shapeStyle: AnyShapeStyle? = nil) {
        self.shapeStyle = shapeStyle
    }

    public func makeBody(configuration: Configuration) -> some View {
        Button {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            configuration.isOn.toggle()
        } label: {
            HStack {
                let fill: AnyShapeStyle = {
                    if let shapeStyle {
                        return configuration.isOn ? shapeStyle : AnyShapeStyle(Tokens.Color.secondarySystemFill.color)
                    } else {
                        return AnyShapeStyle(configuration.isOn ? Tokens.Color.label.color : Tokens.Color.secondarySystemFill.color)
                    }
                }()
                
                if #available(iOS 18.0, *) {
                    Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                        .large()
                        .foregroundStyle(fill)
                        .scaleEffect(animate ? 0.85 : 1)
                        .animation(.bouncy(duration: 0.3), value: animate)
                        .contentTransition(
                            .symbolEffect(
                                .replace.magic(fallback: .downUp.byLayer),
                                options: .nonRepeating
                            )
                        )
                } else {
                    Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                        .large()
                        .foregroundStyle(fill)
                        .scaleEffect(animate ? 0.85 : 1)
                        .animation(.bouncy(duration: 0.3), value: animate)
                        .transition(.opacity)
                }
                
                configuration.label
                    .multilineTextAlignment(.leading)
            }
        }
    }
}

public extension ToggleStyle where Self == ToggleCheckboxStyle {
    public static var checkbox: ToggleCheckboxStyle { .init() }
    
    public static func checkbox<S: ShapeStyle>(_ shapeStyle: S) -> ToggleCheckboxStyle {
        .init(shapeStyle: AnyShapeStyle(shapeStyle))
    }
    
    public static func checkbox(_ color: Color) -> ToggleCheckboxStyle {
        .init(shapeStyle: AnyShapeStyle(color))
    }
}

// MARK: - Previews

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var checked1 = false
    @Previewable @State var checked2 = true
    @Previewable @State var checked3 = true
    @Previewable @State var checked4 = true
    @Previewable @State var checked5 = true
    @Previewable @State var checked6 = true

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
        
        Toggle("ToggleStyle", isOn: $checked4)
            .toggleStyle(.checkbox)
            .tint(.primary)

        Toggle("ToggleStyle with color", isOn: $checked5)
            .toggleStyle(.checkbox(.purple))
            .tint(.primary)
            .body()

        Toggle("ToggleStyle with ShapStyle", isOn: $checked6)
            .toggleStyle(.checkbox(LinearGradient.init(colors: [.yellow, .green], startPoint: .leading, endPoint: .trailing)))
            .callout()
            .tint(.primary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
}
