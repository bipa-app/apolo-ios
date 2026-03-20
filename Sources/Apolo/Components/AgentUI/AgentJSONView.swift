//
//  AgentJSONView.swift
//  Apolo
//
//  Copyright © 2026 Bipa. All rights reserved.
//

#if canImport(SwiftUIJSONRender)
import SwiftUI
import SwiftUIJSONRender

// MARK: - Public Entry Point

/// Renders agent UI JSON using Apolo design system components.
///
/// Pass the raw JSON from `render_ui` and this view handles everything:
/// parsing, display mode routing, and rendering with Apolo builders.
///
/// ```swift
/// // Inline rendering in chat
/// AgentJSONView(json: block.jsonUI)
///
/// // With input handling
/// AgentJSONView(json: block.jsonUI) { response in
///     viewModel.handleInput(response)
/// }
/// ```
public struct AgentJSONView: View {
    private let json: String
    private let inputHandler: InputHandler?

    public init(json: String, onInput: InputHandler? = nil) {
        self.json = json
        self.inputHandler = onInput
    }

    public var body: some View {
        if let request = RenderRequest.from(json: json) {
            switch request.display {
            case .inline:
                jsonView(for: request.root)

            case .document:
                AgentDocumentPreview(
                    title: request.document?.title ?? "Documento",
                    preview: request.document?.preview
                ) {
                    jsonView(for: request.root)
                }
            }
        } else if let node = ComponentNode.from(json: json) {
            // Fallback: bare component node without envelope
            jsonView(for: node)
        }
    }

    private func jsonView(for node: ComponentNode) -> some View {
        JSONView(node)
            .componentRegistry(ApoloAgentRegistry.shared)
            .unknownComponentBehavior(.skip)
            .onInput { response in
                inputHandler?(response)
            }
    }
}

// MARK: - Apolo Agent Registry

/// Component registry with Apolo-native builders for every DSL primitive
/// AND overrides for the library's generic components (Button, Text, Heading, etc.)
/// so everything renders with Apolo typography, buttons, tokens, and glass.
enum ApoloAgentRegistry {
    static let shared: ComponentRegistry = {
        let registry = ComponentRegistry.shared.copy()

        // Agent DSL primitives → Apolo AgentUI components
        registry.register(ApoloCardBuilder.self)
        registry.register(ApoloMetricBuilder.self)
        registry.register(ApoloChartBuilder.self)
        registry.register(ApoloTableBuilder.self)
        registry.register(ApoloListBuilder.self)
        registry.register(ApoloActionBuilder.self)
        registry.register(ApoloInputBuilder.self)
        registry.register(ApoloTextBuilder.self)

        // Override library generics → Apolo styling
        registry.register(ApoloButtonBuilder.self)
        registry.register(ApoloHeadingBuilder.self)
        registry.register(ApoloGenericTextBuilder.self)
        registry.register(ApoloGenericCardBuilder.self)
        registry.register(ApoloDividerBuilder.self)
        registry.register(ApoloAlertBuilder.self)

        return registry
    }()
}

// MARK: - Color / Icon Helpers

private func resolveColor(_ name: String?) -> Color? {
    guard let name else { return nil }
    let semantic = AgentSemanticColor.from(name)
    return semantic == .neutral && name != "neutral" ? nil : semantic.color
}

private func resolveIcon(_ name: String?) -> String? {
    guard let name else { return nil }
    switch name {
    case "btc", "bitcoin": return "bitcoinsign.circle.fill"
    case "usdt", "dollar": return "dollarsign.circle.fill"
    case "brl", "real": return "brazilianrealsign.circle.fill"
    case "card", "credit": return "creditcard.fill"
    case "pix": return "arrow.left.arrow.right"
    default: return name
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: — Agent DSL Primitives (card, metric, chart, etc.)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// MARK: card → AgentCard

struct ApoloCardBuilder: ComponentBuilder {
    public static var typeName: String { "card" }

    @MainActor
    public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
        AnyView(
            AgentCard(
                title: node.string("title"),
                icon: resolveIcon(node.string("icon")),
                iconColor: resolveColor(node.string("iconColor"))
            ) {
                ForEach(Array((node.children ?? []).enumerated()), id: \.offset) { _, child in
                    context.render(child)
                }
            }
        )
    }
}

// MARK: metric → AgentMetric

struct ApoloMetricBuilder: ComponentBuilder {
    public static var typeName: String { "metric" }

    @MainActor
    public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
        AnyView(
            AgentMetric(
                label: node.string("label") ?? "",
                value: node.string("value") ?? "",
                caption: node.string("caption"),
                captionColor: resolveColor(node.string("captionColor")),
                icon: resolveIcon(node.string("icon")),
                iconColor: resolveColor(node.string("iconColor"))
            )
        )
    }
}

// MARK: chart → AgentChart

struct ApoloChartBuilder: ComponentBuilder {
    public static var typeName: String { "chart" }

    @MainActor
    public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
        let style = node.string("style") ?? "sparkline"
        let data = node.array("data")?.compactMap { ($0 as? NSNumber)?.doubleValue } ?? []
        let color = resolveColor(node.string("color")) ?? AgentSemanticColor.accent.color
        let labels = node.array("labels")?.compactMap { $0 as? String }
        let height: CGFloat = {
            if let h = node.double("height") { return CGFloat(h) }
            switch style {
            case "bar": return 140
            case "progress": return 8
            default: return 80
            }
        }()

        return AnyView(
            AgentChart(
                style: style == "bar" ? .bar(labels: labels) : (style == "progress" ? .progress : .sparkline),
                data: data,
                color: color,
                height: height
            )
        )
    }
}

// MARK: table → AgentTable

struct ApoloTableBuilder: ComponentBuilder {
    public static var typeName: String { "table" }

    @MainActor
    public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
        let rows = node.array("rows")?.compactMap { item -> AgentTable.Row? in
            guard let dict = item as? [String: Any],
                  let label = dict["label"] as? String,
                  let value = dict["value"] as? String,
                  !value.isEmpty
            else { return nil }
            return AgentTable.Row(label: label, value: value)
        } ?? []
        return AnyView(AgentTable(rows: rows, maxVisible: node.int("maxVisible")))
    }
}

// MARK: list → AgentList

struct ApoloListBuilder: ComponentBuilder {
    public static var typeName: String { "list" }

    @MainActor
    public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
        let items = node.array("items")?.compactMap { item -> AgentList.Item? in
            guard let dict = item as? [String: Any],
                  let title = dict["title"] as? String
            else { return nil }
            return AgentList.Item(
                title: title,
                subtitle: dict["subtitle"] as? String,
                trailing: dict["trailing"] as? String,
                trailingColor: resolveColor(dict["trailingColor"] as? String),
                icon: dict["icon"] as? String
            )
        } ?? []
        return AnyView(
            AgentList(
                items: items,
                expandLabel: node.string("expandLabel")
            )
        )
    }
}

// MARK: action → AgentAction

struct ApoloActionBuilder: ComponentBuilder {
    public static var typeName: String { "action" }

    @MainActor
    public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
        let style: AgentActionStyle = {
            switch node.string("style") {
            case "destructive": return .destructive
            case "secondary": return .secondary
            default: return .primary
            }
        }()
        return AnyView(
            AgentAction(
                label: node.string("label") ?? "",
                icon: resolveIcon(node.string("icon")),
                style: style
            ) {
                if let actionValue = node.props?["action"] {
                    context.handleAction(actionValue)
                }
            }
        )
    }
}

// MARK: input → AgentInput variants

struct ApoloInputBuilder: ComponentBuilder {
    public static var typeName: String { "input" }

    @MainActor
    public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
        let inputType = node.string("inputType") ?? "text"
        let inputId = node.string("id") ?? UUID().uuidString
        let label = node.string("label") ?? ""

        switch inputType {
        case "choice":
            let options = parseOptions(node)
            return AnyView(AgentChoiceInput(label: label, options: options) { id in
                context.handleInput(InputResponse(inputId: inputId, value: .choice(id)))
            })
        case "multiChoice":
            let options = parseOptions(node)
            return AnyView(AgentMultiChoiceInput(label: label, options: options) { ids in
                context.handleInput(InputResponse(inputId: inputId, value: .multiChoice(ids)))
            })
        case "confirm":
            return AnyView(AgentConfirmInput(
                label: label,
                confirmLabel: node.string("confirmLabel") ?? "Sim",
                cancelLabel: node.string("cancelLabel") ?? "Não"
            ) { value in
                context.handleInput(InputResponse(inputId: inputId, value: .bool(value)))
            })
        case "slider":
            let min = node.double("min") ?? 0
            let max = node.double("max") ?? 100
            let step = node.double("step") ?? 1
            return AnyView(AgentSliderInput(
                label: label,
                range: min...max,
                step: step,
                unit: node.string("unit") ?? ""
            ) { value in
                context.handleInput(InputResponse(inputId: inputId, value: .number(value)))
            })
        default:
            return AnyView(AgentTextInput(
                label: label,
                placeholder: node.string("placeholder") ?? ""
            ) { text in
                context.handleInput(InputResponse(inputId: inputId, value: .text(text)))
            })
        }
    }

    private static func parseOptions(_ node: ComponentNode) -> [AgentChoiceInput.Option] {
        node.array("options")?.compactMap { item -> AgentChoiceInput.Option? in
            guard let dict = item as? [String: Any],
                  let id = dict["id"] as? String,
                  let label = dict["label"] as? String
            else { return nil }
            return AgentChoiceInput.Option(id: id, label: label, subtitle: dict["subtitle"] as? String)
        } ?? []
    }
}

// MARK: text → AgentText

struct ApoloTextBuilder: ComponentBuilder {
    public static var typeName: String { "text" }

    @MainActor
    public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
        let content = node.string("content") ?? ""
        let style: AgentText.Style = {
            switch node.string("style") {
            case "caption": return .caption
            case "headline": return .headline
            default: return .body
            }
        }()
        return AnyView(AgentText(content, style: style))
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: — Library Generic Overrides (Button, Text, Heading, etc.)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// MARK: Button → Apolo button modifiers

struct ApoloButtonBuilder: ComponentBuilder {
    public static var typeName: String { "Button" }

    @MainActor
    public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
        let label = node.string("label") ?? "Button"
        let style = node.string("style") ?? "primary"
        let icon = node.string("icon")
        let disabled = node.bool("disabled") ?? false

        let actionStyle: AgentActionStyle = {
            switch style {
            case "destructive": return .destructive
            case "secondary": return .secondary
            default: return .primary
            }
        }()

        return AnyView(
            AgentAction(
                label: label,
                icon: icon,
                style: actionStyle
            ) {
                if let actionValue = node.props?["action"] {
                    context.handleAction(actionValue)
                }
            }
            .disabled(disabled)
            .opacity(disabled ? 0.5 : 1.0)
        )
    }
}

// MARK: Heading → ABCGinto typography

struct ApoloHeadingBuilder: ComponentBuilder {
    public static var typeName: String { "Heading" }

    @MainActor
    public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
        let content = node.string("content") ?? ""
        let level = node.int("level") ?? 2

        return AnyView(
            Text(content)
                .modifier(HeadingTypography(level: level))
                .foregroundStyle(Tokens.Color.label.color)
                .frame(maxWidth: .infinity, alignment: .leading)
        )
    }
}

private struct HeadingTypography: ViewModifier {
    let level: Int

    func body(content: Content) -> some View {
        switch level {
        case 1: content.title1()
        case 2: content.title2()
        case 3: content.title3()
        case 4: content.headline()
        case 5: content.callout(weight: .medium)
        default: content.subheadline(weight: .medium)
        }
    }
}

// MARK: Text → ABCGinto typography

struct ApoloGenericTextBuilder: ComponentBuilder {
    public static var typeName: String { "Text" }

    @MainActor
    public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
        let content = node.string("content") ?? ""
        let style = node.string("style") ?? "body"
        let colorName = node.string("color")

        let foreground = resolveColor(colorName) ?? Tokens.Color.label.color

        return AnyView(
            Text(content)
                .modifier(TextTypography(style: style))
                .foregroundStyle(foreground)
        )
    }
}

private struct TextTypography: ViewModifier {
    let style: String

    func body(content: Content) -> some View {
        switch style {
        case "caption", "caption1": content.caption1()
        case "caption2": content.caption2()
        case "footnote": content.footnote()
        case "subheadline": content.subheadline()
        case "callout": content.callout()
        case "headline": content.headline()
        case "title3": content.title3()
        case "title2": content.title2()
        case "title1", "title": content.title1()
        case "largeTitle": content.largeTitle()
        default: content.body()
        }
    }
}

// MARK: Card → Apolo .cardBackground() + glass

struct ApoloGenericCardBuilder: ComponentBuilder {
    public static var typeName: String { "Card" }

    @MainActor
    public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
        let title = node.string("title")

        return AnyView(
            VStack(alignment: .leading, spacing: Tokens.Spacing.small) {
                if let title {
                    Text(title)
                        .callout(weight: .medium)
                        .foregroundStyle(Tokens.Color.label.color)
                }
                ForEach(Array((node.children ?? []).enumerated()), id: \.offset) { _, child in
                    context.render(child)
                }
            }
            .padding(Tokens.Spacing.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardBackground()
        )
    }
}

// MARK: Divider → Apolo Separator

struct ApoloDividerBuilder: ComponentBuilder {
    public static var typeName: String { "Divider" }

    @MainActor
    public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
        AnyView(Separator())
    }
}

// MARK: Alert → Apolo Tag

struct ApoloAlertBuilder: ComponentBuilder {
    public static var typeName: String { "Alert" }

    @MainActor
    public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
        let message = node.string("message") ?? ""
        let severity = node.string("severity") ?? "info"

        let tagStyle: Tag.Style = {
            switch severity {
            case "success": return .success
            case "warning": return .warning
            case "error": return .error
            default: return .label(icon: "info.circle.fill")
            }
        }()

        return AnyView(
            Tag(style: tagStyle, title: message)
        )
    }
}

// MARK: - Previews

#Preview("Inline — Balance Card") {
    ScrollView {
        AgentJSONView(json: """
        {
            "display": "inline",
            "root": {
                "type": "card",
                "props": { "title": "Carteiras", "icon": "wallet.bifold.fill" },
                "children": [
                    {
                        "type": "metric",
                        "props": {
                            "label": "Bitcoin",
                            "value": "₿ 0,04521300",
                            "caption": "≈ R$ 25.432,18",
                            "icon": "btc",
                            "iconColor": "bitcoin"
                        }
                    },
                    {
                        "type": "metric",
                        "props": {
                            "label": "USDT",
                            "value": "$ 1.250,00",
                            "caption": "≈ R$ 7.125,00",
                            "icon": "usdt",
                            "iconColor": "dollar"
                        }
                    }
                ]
            }
        }
        """)
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}

#Preview("Inline — Transactions") {
    ScrollView {
        AgentJSONView(json: """
        {
            "display": "inline",
            "root": {
                "type": "card",
                "props": { "title": "Últimas transações", "icon": "clock.arrow.circlepath" },
                "children": [
                    {
                        "type": "list",
                        "props": {
                            "items": [
                                { "title": "PIX para João", "subtitle": "Ontem, 14:30", "trailing": "- R$ 150,00", "trailingColor": "negative", "icon": "arrow.up.right" },
                                { "title": "Salário", "subtitle": "01/03/2026", "trailing": "+ R$ 8.500,00", "trailingColor": "positive", "icon": "arrow.down.left" },
                                { "title": "Netflix", "subtitle": "28/02/2026", "trailing": "- R$ 55,90", "trailingColor": "negative", "icon": "tv" },
                                { "title": "PIX de Maria", "subtitle": "27/02/2026", "trailing": "+ R$ 200,00", "trailingColor": "positive", "icon": "arrow.down.left" },
                                { "title": "Uber", "subtitle": "26/02/2026", "trailing": "- R$ 32,50", "trailingColor": "negative", "icon": "car.fill" },
                                { "title": "Mercado", "subtitle": "25/02/2026", "trailing": "- R$ 430,00", "trailingColor": "negative", "icon": "cart.fill" }
                            ]
                        }
                    }
                ]
            }
        }
        """)
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}

#Preview("Inline — Chart + Table") {
    ScrollView {
        VStack(spacing: Tokens.Spacing.medium) {
            AgentJSONView(json: """
            {
                "display": "inline",
                "root": {
                    "type": "card",
                    "props": { "title": "Bitcoin", "icon": "btc", "iconColor": "bitcoin" },
                    "children": [
                        {
                            "type": "metric",
                            "props": {
                                "label": "Preço atual",
                                "value": "R$ 562.340,00",
                                "caption": "+3,2% hoje",
                                "captionColor": "positive"
                            }
                        },
                        {
                            "type": "chart",
                            "props": {
                                "style": "sparkline",
                                "data": [520, 535, 528, 545, 540, 555, 562],
                                "color": "bitcoin"
                            }
                        }
                    ]
                }
            }
            """)

            AgentJSONView(json: """
            {
                "display": "inline",
                "root": {
                    "type": "card",
                    "props": { "title": "Gastos por categoria" },
                    "children": [
                        {
                            "type": "table",
                            "props": {
                                "rows": [
                                    { "label": "Alimentação", "value": "R$ 1.200,00" },
                                    { "label": "Transporte", "value": "R$ 800,00" },
                                    { "label": "Moradia", "value": "R$ 2.500,00" },
                                    { "label": "Lazer", "value": "R$ 450,00" },
                                    { "label": "Saúde", "value": "R$ 320,00" },
                                    { "label": "Educação", "value": "R$ 280,00" }
                                ]
                            }
                        }
                    ]
                }
            }
            """)
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}

#Preview("Library Components — Apolo Styled") {
    ScrollView {
        VStack(spacing: Tokens.Spacing.medium) {
            // Heading with ABCGinto
            AgentJSONView(json: """
            {
                "display": "inline",
                "root": {
                    "type": "Stack",
                    "props": { "direction": "vertical", "spacing": 12 },
                    "children": [
                        { "type": "Heading", "props": { "content": "Relatório Mensal", "level": 2 } },
                        { "type": "Text", "props": { "content": "Aqui está o resumo das suas finanças em março.", "style": "body" } },
                        { "type": "Divider" },
                        { "type": "Text", "props": { "content": "Dados atualizados em tempo real.", "style": "caption", "color": "neutral" } }
                    ]
                }
            }
            """)

            // Buttons with Apolo modifiers
            AgentJSONView(json: """
            {
                "display": "inline",
                "root": {
                    "type": "Card",
                    "props": { "title": "Ações" },
                    "children": [
                        { "type": "Button", "props": { "label": "Comprar Bitcoin", "style": "primary", "icon": "bitcoinsign.circle.fill" } },
                        { "type": "Button", "props": { "label": "Ver extrato", "style": "secondary" } },
                        { "type": "Button", "props": { "label": "Cancelar", "style": "destructive" } }
                    ]
                }
            }
            """)

            // Alert → Tag
            AgentJSONView(json: """
            {
                "display": "inline",
                "root": {
                    "type": "Stack",
                    "props": { "direction": "vertical", "spacing": 8 },
                    "children": [
                        { "type": "Alert", "props": { "message": "Transferência concluída", "severity": "success" } },
                        { "type": "Alert", "props": { "message": "Pagamento pendente", "severity": "warning" } },
                        { "type": "Alert", "props": { "message": "Erro no processamento", "severity": "error" } }
                    ]
                }
            }
            """)
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}

#Preview("Document — Financial Report") {
    ScrollView {
        AgentJSONView(json: """
        {
            "display": "document",
            "title": "Relatório Financeiro — Março 2026",
            "preview": "R$ 4.523,00 em 47 transações",
            "root": {
                "type": "Stack",
                "props": { "direction": "vertical", "spacing": 16 },
                "children": [
                    {
                        "type": "card",
                        "props": { "title": "Resumo", "icon": "chart.bar.fill" },
                        "children": [
                            {
                                "type": "metric",
                                "props": {
                                    "label": "Total gasto",
                                    "value": "R$ 4.523,00",
                                    "caption": "+12% vs fevereiro",
                                    "captionColor": "negative"
                                }
                            },
                            {
                                "type": "chart",
                                "props": {
                                    "style": "bar",
                                    "data": [1200, 800, 2500, 450, 320, 280],
                                    "labels": ["Comida", "Transp", "Casa", "Lazer", "Saúde", "Educ"],
                                    "color": "real"
                                }
                            }
                        ]
                    },
                    {
                        "type": "card",
                        "props": { "title": "Por categoria" },
                        "children": [
                            {
                                "type": "list",
                                "props": {
                                    "items": [
                                        { "title": "Alimentação", "subtitle": "23 transações", "trailing": "R$ 1.200", "icon": "fork.knife" },
                                        { "title": "Transporte", "subtitle": "12 transações", "trailing": "R$ 800", "icon": "car.fill" },
                                        { "title": "Moradia", "subtitle": "3 transações", "trailing": "R$ 2.500", "icon": "house.fill" },
                                        { "title": "Lazer", "subtitle": "8 transações", "trailing": "R$ 450", "icon": "gamecontroller.fill" },
                                        { "title": "Saúde", "subtitle": "4 transações", "trailing": "R$ 320", "icon": "heart.fill" }
                                    ]
                                }
                            }
                        ]
                    }
                ]
            }
        }
        """)
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}

#Preview("Input — Choice") {
    ScrollView {
        AgentJSONView(json: """
        {
            "display": "inline",
            "root": {
                "type": "card",
                "props": { "title": "Qual seu objetivo?", "icon": "target" },
                "children": [
                    {
                        "type": "input",
                        "props": {
                            "id": "goal",
                            "inputType": "choice",
                            "label": "Escolha uma opção:",
                            "options": [
                                { "id": "save", "label": "Guardar dinheiro", "subtitle": "Reserva de emergência" },
                                { "id": "invest", "label": "Investir", "subtitle": "Crescer patrimônio" },
                                { "id": "travel", "label": "Viajar", "subtitle": "Próximas férias" }
                            ]
                        }
                    }
                ]
            }
        }
        """) { response in
            print("Input: \(response)")
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}
#endif
