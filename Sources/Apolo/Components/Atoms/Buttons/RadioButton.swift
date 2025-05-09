//
//  RadioButton.swift
//  Apolo
//
//  Created by Eric on 19/12/24.
//

import SwiftUI

// MARK: - Radio Button Group

public struct RadioButtonGroup<T: Hashable>: View {
    private let options: [RadioOption<T>]
    @Binding private var selectedValue: T
    private let style: RadioButtonGroupStyle
    private let showSeparators: Bool
    private let onSelect: ((T) -> Void)?
    
    public init(
        options: [RadioOption<T>],
        selectedValue: Binding<T>,
        style: RadioButtonGroupStyle = .default,
        showSeparators: Bool = true,
        onSelect: ((T) -> Void)? = nil
    ) {
        self.options = options
        self._selectedValue = selectedValue
        self.style = style
        self.showSeparators = showSeparators
        self.onSelect = onSelect
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.medium) {
            switch style {
            case .default:
                ForEach(Array(options.enumerated()), id: \.element.id) { index, option in
                    radioButton(index, option)
                }
                
            case .card(let backgroundStyle):
                ForEach(Array(options.enumerated()), id: \.element.id) { index, option in
                    radioButton(index, option)
                        .padding(Tokens.Spacing.medium)
                        .frame(minHeight: 72)
                        .cardBackground(backgroundStyle)
                }
            }
        }
    }
    
    @ViewBuilder
    private func radioButton(_ index: Int, _ option: RadioOption<T>) -> some View {
        RadioButton(
            option: option,
            isSelected: selectedValue == option.value,
            style: option.style
        ) {
            selectedValue = option.value
            onSelect?(option.value)
        }
        
        if index < options.count - 1, showSeparators {
            Separator()
        }
    }
}

// MARK: RadioButtonGroupStyle

public enum RadioButtonGroupStyle {
    
    /// The plain style
    case `default`
    
    /// Apply a cardBackground style
    case card(CardBackground.Style)
}

// MARK: - Radio Option

public struct RadioOption<T: Hashable>: Identifiable {
    public let id: String
    public let value: T
    public let label: String
    public let description: String?
    public let style: RadioButtonStyle
    public let iconName: String?
    public let iconColor: Color?
    public let iconLeading: CGFloat?
    
    public init(
        id: String,
        value: T,
        label: String,
        description: String? = nil,
        style: RadioButtonStyle = .standard,
        iconName: String? = nil,
        iconColor: Color? = nil,
        iconLeading: CGFloat = Tokens.Spacing.extraExtraSmall
    ) {
        self.id = id
        self.value = value
        self.label = label
        self.description = description
        self.style = style
        self.iconName = iconName
        self.iconColor = iconColor
        self.iconLeading = iconLeading
    }
}

// MARK: - Radio Button Style

public enum RadioButtonStyle {
    
    /// Body label with footnote description
    case standard
    
    /// Footnote label with body description/
    case reversed
}

// MARK: - Radio Button

public struct RadioButton<T: Hashable>: View {
    // MARK: - Properties
    
    private let option: RadioOption<T>
    private let isSelected: Bool
    private let style: RadioButtonStyle
    private let action: () -> Void
    @State private var animate: Bool = false
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    init(
        option: RadioOption<T>,
        isSelected: Bool,
        style: RadioButtonStyle = .standard,
        action: @escaping () -> Void
    ) {
        self.option = option
        self.isSelected = isSelected
        self.style = style
        self.action = action
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack {
            radioCircle

            if let iconName = option.iconName {
                Image(systemName: iconName)
                    .regular()
                    .foregroundColor(option.iconColor ?? .primary)
                    .padding(.trailing, 4)
                    .padding(.leading, option.iconLeading)
            }
            
            labelStack
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(.containerRelative)
        .gesture(tapGesture.simultaneously(with: pressGesture))

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
    }
    
    private var labelStack: some View {
        VStack(alignment: .leading) {
            switch style {
            case .standard:
                Text(option.label)
                    .callout(weight: .medium)
                
                if let description = option.description {
                    Text(description)
                        .subheadline()
                        .foregroundStyle(Color.secondary)
                }
            case .reversed:
                Text(option.label)
                    .subheadline()
                    .foregroundStyle(Color.secondary)
                
                if let description = option.description {
                    Text(description)
                        .callout(weight: .medium)
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
                action()
            }
    }
}

// MARK: - Preview

private enum PreviewOption: String, CaseIterable {
    case first, second, third
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var selectedValue: PreviewOption = .first
    
    let options = [
        RadioOption(
            id: PreviewOption.first.rawValue,
            value: PreviewOption.first,
            label: "First Option",
            description: "Bitcoin was made by Satoshi Nakamoto",
            iconName: "bitcoinsign.circle.fill",
            iconColor: .orange
        ),
        RadioOption(
            id: PreviewOption.second.rawValue,
            value: PreviewOption.second,
            label: "Second Option",
            description: "Bitcoin was made by Satoshi Nakamoto",
            style: .reversed,
            iconName: "creditcard.fill",
            iconColor: .blue
        ),
        RadioOption(
            id: PreviewOption.third.rawValue,
            value: PreviewOption.third,
            label: "Third Option",
            iconName: "car",
            iconColor: .primary
        )
    ]
    
    ScrollView(.vertical) {
        VStack {
            Section("RadioButtonGroupStyle - Default") {
                RadioButtonGroup(
                    options: options,
                    selectedValue: $selectedValue
                ) { newSelectedValue in
                    print("Selected option: \(newSelectedValue)")
                }
            }
            
            Spacer(minLength: Tokens.Spacing.extraExtraLarge)
            
            Section("RadioButtonGroupStyle - Card") {
                RadioButtonGroup(
                    options: options,
                    selectedValue: $selectedValue,
                    style: .card(.secondary),
                    showSeparators: false
                )
            }
        }
        .padding()
    }
}
