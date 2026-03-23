//
//  AgentInput.swift
//  Apolo
//
//  Input collection components using Apolo atoms
//  (RadioButtonGroup, Checkbox, Separator).
//

import SwiftUI

// MARK: - Agent Choice Input

/// Single-select using Apolo RadioButtonGroup with `.plain` style.
public struct AgentChoiceInput: View {
    public let label: String
    public let options: [Option]
    public let onSelect: (String) -> Void

    @State private var selectedId: String = ""

    public struct Option: Identifiable, Hashable {
        public let id: String
        public let label: String
        public let subtitle: String?

        public init(id: String, label: String, subtitle: String? = nil) {
            self.id = id
            self.label = label
            self.subtitle = subtitle
        }
    }

    public init(label: String, options: [Option], onSelect: @escaping (String) -> Void) {
        self.label = label
        self.options = options
        self.onSelect = onSelect
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.small) {
            Text(label)
                .body()
                .foregroundStyle(Tokens.Color.label.color)

            VStack(spacing: .zero) {
                ForEach(Array(options.enumerated()), id: \.element.id) { idx, option in
                    Button {
                        withAnimation(.bouncy(duration: 0.2)) {
                            selectedId = option.id
                        }
                        performHaptic(.light)
                        onSelect(option.id)
                    } label: {
                        HStack(spacing: Tokens.Spacing.medium) {
                            ZStack {
                                Circle()
                                    .fill(selectedId == option.id ? Tokens.Color.label.color : Color.clear)
                                    .frame(width: 10, height: 10)
                                Circle()
                                    .stroke(Tokens.Color.secondaryLabel.color.opacity(0.5), lineWidth: 1)
                                    .frame(width: 24, height: 24)
                            }

                            VStack(alignment: .leading, spacing: Tokens.Spacing.extraExtraSmall) {
                                Text(option.label)
                                    .callout(weight: .medium)
                                    .foregroundStyle(Tokens.Color.label.color)
                                if let subtitle = option.subtitle {
                                    Text(subtitle)
                                        .subheadline()
                                        .foregroundStyle(Tokens.Color.secondaryLabel.color)
                                }
                            }

                            Spacer()
                        }
                        .padding(Tokens.Spacing.medium)
                        .frame(minHeight: 60)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)

                    if idx < options.count - 1 {
                        Separator()
                            .padding(.leading, Tokens.Spacing.medium + 24 + Tokens.Spacing.medium)
                    }
                }
            }
            .cardBackground(.secondary, cornerRadius: Tokens.CornerRadius.medium)
        }
    }
}

// MARK: - Agent Multi-Choice Input

/// Multi-select using Apolo Checkbox style.
public struct AgentMultiChoiceInput: View {
    public let label: String
    public let options: [AgentChoiceInput.Option]
    public let onSelect: ([String]) -> Void

    @State private var selectedIds: Set<String> = []

    public init(
        label: String,
        options: [AgentChoiceInput.Option],
        onSelect: @escaping ([String]) -> Void
    ) {
        self.label = label
        self.options = options
        self.onSelect = onSelect
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.small) {
            Text(label)
                .body()
                .foregroundStyle(Tokens.Color.label.color)

            VStack(spacing: .zero) {
                ForEach(Array(options.enumerated()), id: \.element.id) { idx, option in
                    let isSelected = selectedIds.contains(option.id)

                    Button {
                        withAnimation(.bouncy(duration: 0.2)) {
                            if isSelected {
                                selectedIds.remove(option.id)
                            } else {
                                selectedIds.insert(option.id)
                            }
                        }
                        performHaptic(.light)
                    } label: {
                        HStack(spacing: Tokens.Spacing.medium) {
                            Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                                .large()
                                .foregroundStyle(
                                    isSelected
                                        ? Tokens.Color.label.color
                                        : Tokens.Color.secondarySystemFill.color
                                )

                            VStack(alignment: .leading, spacing: Tokens.Spacing.extraExtraSmall) {
                                Text(option.label)
                                    .callout(weight: .medium)
                                    .foregroundStyle(Tokens.Color.label.color)
                                if let subtitle = option.subtitle {
                                    Text(subtitle)
                                        .subheadline()
                                        .foregroundStyle(Tokens.Color.secondaryLabel.color)
                                }
                            }

                            Spacer()
                        }
                        .padding(Tokens.Spacing.medium)
                        .frame(minHeight: 60)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)

                    if idx < options.count - 1 {
                        Separator()
                            .padding(.leading, Tokens.Spacing.medium + 22 + Tokens.Spacing.medium)
                    }
                }
            }
            .cardBackground(.secondary, cornerRadius: Tokens.CornerRadius.medium)

            Button {
                onSelect(Array(selectedIds))
            } label: {
                Text("Confirmar (\(selectedIds.count))")
                    .body()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Tokens.Color.systemBackground.color)
            }
            .borderedProminentStyle(color: Tokens.Color.label.color)
            .disabled(selectedIds.isEmpty)
        }
    }
}

// MARK: - Agent Text Input

public struct AgentTextInput: View {
    public let label: String
    public let placeholder: String
    public let onSubmit: (String) -> Void

    @State private var text = ""

    public init(label: String, placeholder: String = "", onSubmit: @escaping (String) -> Void) {
        self.label = label
        self.placeholder = placeholder
        self.onSubmit = onSubmit
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.small) {
            Text(label)
                .body()
                .foregroundStyle(Tokens.Color.label.color)

            HStack(spacing: Tokens.Spacing.small) {
                TextField(placeholder, text: $text)
                    .body()
                    .textFieldStyle(.plain)
                    .onSubmit {
                        guard !text.isEmpty else { return }
                        onSubmit(text)
                    }

                if !text.isEmpty {
                    Button {
                        onSubmit(text)
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .large()
                            .foregroundStyle(Tokens.Color.violet.color)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(Tokens.Spacing.small)
            .cardBackground(.secondary, cornerRadius: Tokens.CornerRadius.medium)
        }
    }
}

// MARK: - Agent Confirm Input

public struct AgentConfirmInput: View {
    public let label: String
    public let confirmLabel: String
    public let cancelLabel: String
    public let onConfirm: (Bool) -> Void

    public init(
        label: String,
        confirmLabel: String = "Sim",
        cancelLabel: String = "Não",
        onConfirm: @escaping (Bool) -> Void
    ) {
        self.label = label
        self.confirmLabel = confirmLabel
        self.cancelLabel = cancelLabel
        self.onConfirm = onConfirm
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.small) {
            Text(label)
                .body()
                .foregroundStyle(Tokens.Color.label.color)

            HStack(spacing: Tokens.Spacing.small) {
                Button {
                    onConfirm(false)
                } label: {
                    Text(cancelLabel)
                        .body()
                        .frame(maxWidth: .infinity)
                }
                .borderedStyle(color: Tokens.Color.label.color, isClear: true)

                Button {
                    onConfirm(true)
                } label: {
                    Text(confirmLabel)
                        .body()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Tokens.Color.systemBackground.color)
                }
                .borderedProminentStyle(color: Tokens.Color.label.color)
            }
        }
    }
}

// MARK: - Agent Slider Input

public struct AgentSliderInput: View {
    public let label: String
    public let range: ClosedRange<Double>
    public let step: Double
    public let unit: String
    public let onChange: (Double) -> Void

    @State private var value: Double = 0
    @State private var didAppear = false

    public init(
        label: String,
        range: ClosedRange<Double> = 0...100,
        step: Double = 1,
        unit: String = "",
        onChange: @escaping (Double) -> Void
    ) {
        self.label = label
        self.range = range
        self.step = step
        self.unit = unit
        self.onChange = onChange
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.small) {
            Text(label)
                .body()
                .foregroundStyle(Tokens.Color.label.color)

            VStack(spacing: Tokens.Spacing.extraSmall) {
                HStack {
                    Text(String(format: "%.0f", value) + (unit.isEmpty ? "" : " \(unit)"))
                        .title3(weight: .medium)
                        .foregroundStyle(Tokens.Color.label.color)
                        .monospacedDigit()
                    Spacer()
                }

                Slider(value: $value, in: range, step: step)
                    .tint(Tokens.Color.violet.color)
                    .onChange(of: value) { newValue in
                        guard didAppear else { return }
                        onChange(newValue)
                    }
            }
        }
        .onAppear {
            value = range.lowerBound
            didAppear = true
        }
    }
}

// MARK: - Previews

#Preview("Choice") {
    AgentChoiceInput(
        label: "Qual seu objetivo?",
        options: [
            .init(id: "emergency", label: "Reserva de emergência", subtitle: "3-6 meses de gastos"),
            .init(id: "retirement", label: "Aposentadoria", subtitle: "Longo prazo"),
            .init(id: "travel", label: "Viagem", subtitle: "Próximos 12 meses"),
        ],
        onSelect: { _ in }
    )
    .padding()
}

#Preview("Multi-Choice") {
    AgentMultiChoiceInput(
        label: "Quais categorias acompanhar?",
        options: [
            .init(id: "food", label: "Alimentação"),
            .init(id: "transport", label: "Transporte"),
            .init(id: "housing", label: "Moradia"),
            .init(id: "leisure", label: "Lazer"),
        ],
        onSelect: { _ in }
    )
    .padding()
}

#Preview("Text Input") {
    AgentTextInput(label: "Para qual chave PIX?", placeholder: "CPF, e-mail ou telefone") { _ in }
        .padding()
}

#Preview("Confirm") {
    AgentConfirmInput(label: "Deseja continuar?", confirmLabel: "Sim, continuar", cancelLabel: "Não") { _ in }
        .padding()
}

#Preview("Slider") {
    AgentSliderInput(label: "Nível de risco", range: 1...10, step: 1) { _ in }
        .padding()
}
