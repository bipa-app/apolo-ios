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
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(.rect)
        .gesture(tapGesture)
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
                .scaleEffect(animate ? 0.95 : 1)
                .animation(.bouncy(duration: 0.2), value: animate)
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
                .scaleEffect(animate ? 0.95 : 1)
                .animation(.bouncy(duration: 0.2), value: animate)
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

    private var tapGesture: some Gesture {
        TapGesture()
            .onEnded {
                feedbackGenerator.impactOccurred()
                withAnimation(.bouncy(duration: 0.2)) {
                    animate = true
                }
                isChecked.toggle()
                onCheck?(isChecked)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                    withAnimation(.bouncy(duration: 0.2)) {
                        animate = false
                    }
                }
            }
    }
}

// MARK: - Toogle Modifier

public struct ToggleCheckboxStyle: ToggleStyle {
    @State private var animate: Bool = false
    private let shapeStyle: AnyShapeStyle?
    private let hasLabel: Bool
    
    public init(shapeStyle: AnyShapeStyle? = nil, hasLabel: Bool) {
        self.shapeStyle = shapeStyle
        self.hasLabel = hasLabel
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
                        .scaleEffect(animate ? 0.95 : 1)
                        .animation(.bouncy(duration: 0.2), value: animate)
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
                        .scaleEffect(animate ? 0.95 : 1)
                        .animation(.bouncy(duration: 0.2), value: animate)
                        .transition(.opacity)
                }
                
                if hasLabel {
                    configuration.label
                        .multilineTextAlignment(.leading)
                    
                    Spacer(minLength: 0)
                }
            }
            .frame(maxWidth: hasLabel ? .infinity : nil, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

public extension ToggleStyle where Self == ToggleCheckboxStyle {
    static var apoloCheckbox: ToggleCheckboxStyle { .init(hasLabel: true) }
    
    static func apoloCheckbox<S: ShapeStyle>(_ shapeStyle: S, hasLabel: Bool = true) -> ToggleCheckboxStyle {
        .init(shapeStyle: AnyShapeStyle(shapeStyle), hasLabel: hasLabel)
    }
    
    static func apoloCheckbox(_ color: Color, hasLabel: Bool = true) -> ToggleCheckboxStyle {
        .init(shapeStyle: AnyShapeStyle(color), hasLabel: hasLabel)
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
            .toggleStyle(.apoloCheckbox)
            .tint(.primary)

        Toggle("ToggleStyle with color", isOn: $checked5)
            .toggleStyle(.apoloCheckbox(.purple))
            .tint(.primary)
            .body()

        Toggle("ToggleStyle with ShapStyle", isOn: $checked6)
            .toggleStyle(.apoloCheckbox(LinearGradient.init(colors: [.yellow, .green], startPoint: .leading, endPoint: .trailing)))
            .callout()
            .tint(.primary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
}
