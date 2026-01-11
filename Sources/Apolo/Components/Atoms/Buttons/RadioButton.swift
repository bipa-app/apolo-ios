//
//  RadioButton.swift
//  Apolo
//
//  Created by Eric on 19/12/24.
//

import SwiftUI

#if !os(watchOS)

// MARK: - RadioButtonGroupStyle

public enum RadioButtonGroupStyle {
    
    /// The plain style
    case plain
    
    /// Apply a cardBackground style for all items
    case card(CardBackground.Style)
    
    /// Apply a cardBackground style only to selected item
    case selectedCard(CardBackground.Style)
}

// MARK: - Radio Button Group

public struct RadioButtonGroup<T: Hashable>: View {
    
    private let style: RadioButtonGroupStyle
    private let options: [RadioOption<T>]
    @Binding private var selectedValue: T
    private let onSelect: ((T) -> Void)?
    
    public init(
        style: RadioButtonGroupStyle,
        options: [RadioOption<T>],
        selectedValue: Binding<T>,
        onSelect: ((T) -> Void)? = nil
    ) {
        self.style = style
        self.options = options
        self._selectedValue = selectedValue
        self.onSelect = onSelect
    }
    
    public var body: some View {
        switch style {
        case .plain:
            plainGroup
            
        case .card(let style):
            cardGroup(style)
            
        case .selectedCard(let style):
            selectedCardGroup(style)
        }
    }
}

// MARK: RadioButtonGroup styles

extension RadioButtonGroup {
    private var plainGroup: some View {
        VStack(alignment: .leading, spacing: .zero) {
            ForEach(Array(options.enumerated()), id: \.element.id) { index, option in
                RadioButton(
                    option: option,
                    isSelected: selectedValue == option.value,
                    style: option.style
                ) {
                    selectedValue = option.value
                    onSelect?(option.value)
                }
                .id(option.id)
                
                if index < options.count - 1 {
                    Separator()
                }
            }
        }
    }

    private func cardGroup(_ style: CardBackground.Style) -> some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.medium) {
            ForEach(Array(options.enumerated()), id: \.element.id) { index, option in
                RadioButton(
                    option: option,
                    isSelected: selectedValue == option.value,
                    style: option.style
                ) {
                    selectedValue = option.value
                    onSelect?(option.value)
                }
                .id(option.id)
                .padding(Tokens.Spacing.medium)
                .frame(minHeight: 72)
                .cardBackground(style)
            }
        }
    }

    private func selectedCardGroup(_ style: CardBackground.Style) -> some View {
        VStack(alignment: .leading, spacing: .zero) {
            ForEach(Array(options.enumerated()), id: \.element.id) { index, option in
                if selectedValue == option.value {
                    RadioButton(
                        option: option,
                        isSelected: selectedValue == option.value,
                        style: option.style
                    ) {
                        selectedValue = option.value
                        onSelect?(option.value)
                    }
                    .id(option.id)
                    .cardBackground(style)
                } else {
                    RadioButton(
                        option: option,
                        isSelected: selectedValue == option.value,
                        style: option.style
                    ) {
                        selectedValue = option.value
                        onSelect?(option.value)
                    }
                    .id(option.id)
                }
            }
        }
    }
}

// MARK: - Radio Button Style

public enum RadioButtonStyle {
    
    /// Body label with footnote description
    case standard
    
    /// Footnote label with body description
    case reversed
    
    /// Just use this style in case of customView initializer
    case custom
}

public struct RadioButtonIconConfiguration {
    public let image: Image?
    public let color: Color?
    
    public init(
        image: Image? = nil,
        color: Color? = nil
    ) {
        self.image = image
        self.color = color
    }
}

// MARK: - Radio Option

public struct RadioOption<T: Hashable>: Identifiable {
    public let id: String
    public let value: T
    public let label: String?
    public let description: String?
    public let style: RadioButtonStyle
    public let iconConfiguration: RadioButtonIconConfiguration?
    public let tag: Tag?
    public let customView: AnyView?

    // MARK: Default initializer

    public init(
        id: String,
        value: T,
        label: String? = nil,
        description: String? = nil,
        style: RadioButtonStyle = .standard,
        iconConfiguration: RadioButtonIconConfiguration? = nil,
        withTag tag: Tag? = nil
    ) {
        self.id = id
        self.value = value
        self.label = label
        self.description = description
        self.style = style
        self.iconConfiguration = iconConfiguration
        self.tag = tag
        self.customView = nil
    }
    
    // MARK: CustomView initializer
    
    public init<CustomView: View>(
        id: String,
        value: T,
        @ViewBuilder customView: () -> CustomView
    ) {
        self.id = id
        self.value = value
        self.label = nil
        self.description = nil
        self.style = .custom
        self.iconConfiguration = nil
        self.tag = nil
        self.customView = AnyView(customView())
    }
}

// MARK: - Radio Button

public struct RadioButton<T: Hashable>: View {    
    private let option: RadioOption<T>
    private let isSelected: Bool
    private let style: RadioButtonStyle
    private let action: () -> Void
    @State private var animate: Bool = false
    #if !os(watchOS)
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    #endif
    
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
        HStack(spacing: Tokens.Spacing.medium) {
            radioCircle
            
            if let customView = option.customView {
                customView
            } else {
                defaultView
            }
        }
        .padding(Tokens.Spacing.medium)
        .frame(minHeight: 77)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(.containerRelative)
        .onTapGesture {
            animate = true
            #if !os(watchOS)
                feedbackGenerator.impactOccurred()
                #endif
            action()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                animate = false
            }
        }
    }
        
    // MARK: - UI Components
    
    private var radioCircle: some View {
        ZStack {
            Circle()
                .fill(isSelected ? Color.primary : Color.clear)
                .frame(width: 10, height: 10)
            Circle()
                .stroke(.secondary.opacity(0.5), lineWidth: 1)
                .frame(width: 24, height: 24)
        }
        .scaleEffect(x: animate ? 0.95 : 1, y: animate ? 0.95 : 1)
        .animation(.bouncy(duration: 0.3), value: animate)
    }
    
    @ViewBuilder
    private var defaultView: some View {
        if let iconConfig = option.iconConfiguration, let image = iconConfig.image {
            image
                .large()
                .foregroundColor(iconConfig.color ?? .primary)
        }
        
        labelStack
            .frame(maxWidth: .infinity, alignment: .leading)
        
        if let tag = option.tag {
            tag
                .minimumScaleFactor(0.8)
                .lineLimit(1)
        }
    }
    
    @ViewBuilder
    private var labelStack: some View {
        switch style {
        case .standard:
            standardLabel
            
        case .reversed:
            reversedLabel
            
        case .custom:
            EmptyView()
        }
    }
    
    private var standardLabel: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.extraExtraSmall) {
            if let label = option.label {
                Text(label)
                .callout(weight: .medium)
            }
            
            if let description = option.description {
                Text(description)
                    .subheadline()
                    .foregroundStyle(Color.secondary)
            }
        }
    }
    
    private var reversedLabel: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.extraExtraSmall) {
            if let label = option.label {
                Text(label)
                    .subheadline()
                    .foregroundStyle(Color.secondary)
            }
            
            if let description = option.description {
                Text(description)
                    .callout(weight: .medium)
            }
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
            iconConfiguration: RadioButtonIconConfiguration(
                image: Image(systemName: "bitcoinsign.circle.fill"),
                color: .orange
            )
        ),
        RadioOption(
            id: PreviewOption.second.rawValue,
            value: PreviewOption.second,
            label: "Second Option",
            description: "Bitcoin was made by Satoshi Nakamoto",
            style: .reversed,
            iconConfiguration: RadioButtonIconConfiguration(
                image: Image(systemName: "creditcard.fill"),
                color: .blue
            )
        ),
        RadioOption(
            id: PreviewOption.third.rawValue,
            value: PreviewOption.third,
            label: "Third Option",
            iconConfiguration: RadioButtonIconConfiguration(
                image: Image(systemName: "car"),
                color: .primary
            )
        )
    ]
    
    let customViewOptions: [RadioOption] = [
        RadioOption(
            id: 1.description,
            value: PreviewOption.first,
            customView: {
                VStack {
                    Text("Customize the view how u want")
                        .body()
                        .background(.yellow)
                    Text("Customize the view how u want")
                        .body()
                        .background(.green)
                    Text("Customize the view how u want")
                        .body()
                        .background(.blue)
                }
            }
        ),
        RadioOption(
            id: 2.description,
            value: PreviewOption.second,
            customView: {
                VStack {
                    Text("Customize the view how u want")
                        .callout()
                        .foregroundStyle(.red)
                    HStack {
                        Image(systemName: "bitcoinsign")
                        Image(systemName: "dollarsign")
                        Image(systemName: "bitcoinsign")
                        Image(systemName: "dollarsign")
                        Image(systemName: "bitcoinsign")
                        Image(systemName: "dollarsign")
                        Image(systemName: "bitcoinsign")
                        Image(systemName: "dollarsign")
                        Image(systemName: "bitcoinsign")
                        Image(systemName: "dollarsign")
                    }
                }
            }
        )
    ]
    
    ScrollView(.vertical) {
        VStack(spacing: Tokens.Spacing.extraExtraLarge) {
            Section("RadioButtonGroupStyle - Plain") {
                RadioButtonGroup(
                    style: .plain,
                    options: options,
                    selectedValue: $selectedValue
                ) { newSelectedValue in
                    print("Selected option: \(newSelectedValue)")
                }
            }
                        
            Section("RadioButtonGroupStyle - Card") {
                RadioButtonGroup(
                    style: .card(.secondary),
                    options: options,
                    selectedValue: $selectedValue
                )
            }
                        
            Section("RadioButtonGroupStyle - SelectedCard") {
                RadioButtonGroup(
                    style: .selectedCard(.secondary),
                    options: options,
                    selectedValue: $selectedValue
                )
            }
                        
            Section("RadioButtonGroupStyle - CustomView") {
                RadioButtonGroup(
                    style: .plain,
                    options: customViewOptions,
                    selectedValue: $selectedValue
                )
            }
        }
        .padding()
    }
}

#endif
