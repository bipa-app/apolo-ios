import MarkdownUI
import SwiftUI
import Textual

// MARK: - Markdown Style Configuration

/// Configuration for customizing markdown appearance.
/// Use presets like `.default` or `.secondary`, or create custom configurations.
public struct MarkdownStyleConfiguration {
    // MARK: - Customizable Colors

    /// Primary text color for body text and headings.
    public var textColor: Tokens.Color

    /// Accent color for links, code text, list markers, and blockquote bars.
    public var accentColor: Tokens.Color

    /// Secondary text color for strikethrough, blockquote text, and H6 headings.
    public var secondaryTextColor: Tokens.Color

    /// Tertiary text color for thematic breaks.
    public var tertiaryTextColor: Tokens.Color

    /// Background color for inline code.
    public var codeBackground: Tokens.Color

    /// Background color for code blocks.
    public var codeBlockBackground: Tokens.Color

    /// Color for table borders and alternating row backgrounds.
    public var tableBorderColor: Tokens.Color

    // MARK: - Initialization

    /// Creates a custom markdown style configuration.
    public init(
        textColor: Tokens.Color = .label,
        accentColor: Tokens.Color = .orange,
        secondaryTextColor: Tokens.Color = .secondaryLabel,
        tertiaryTextColor: Tokens.Color = .tertiaryLabel,
        codeBackground: Tokens.Color = .secondarySystemFill,
        codeBlockBackground: Tokens.Color = .secondarySystemBackground,
        tableBorderColor: Tokens.Color = .tertiarySystemFill
    ) {
        self.textColor = textColor
        self.accentColor = accentColor
        self.secondaryTextColor = secondaryTextColor
        self.tertiaryTextColor = tertiaryTextColor
        self.codeBackground = codeBackground
        self.codeBlockBackground = codeBlockBackground
        self.tableBorderColor = tableBorderColor
    }

    // MARK: - Presets

    /// Default style with primary text color.
    public static let `default` = MarkdownStyleConfiguration()

    /// Secondary style with muted text color.
    public static let secondary = MarkdownStyleConfiguration(
        textColor: .secondaryLabel,
        secondaryTextColor: .tertiaryLabel
    )

    /// Tertiary style with even more muted text color.
    public static let tertiary = MarkdownStyleConfiguration(
        textColor: .tertiaryLabel,
        secondaryTextColor: .quaternaryLabel
    )
}

// MARK: - Internal Style Constants

/// Internal constants for markdown styling that don't need customization.
enum MarkdownStyleConstants {
    // MARK: - Font Families

    static let regularFont = "ABCGinto-Regular"
    static let mediumFont = "ABCGinto-Medium"
    static let italicFont = "ABCGinto-RegularItalic"

    // MARK: - Text Styles (for Dynamic Type)

    static let heading1Style: Font.TextStyle = .title
    static let heading2Style: Font.TextStyle = .title2
    static let heading3Style: Font.TextStyle = .title3
    static let heading4Style: Font.TextStyle = .headline
    static let heading5Style: Font.TextStyle = .subheadline
    static let heading6Style: Font.TextStyle = .footnote
    static let tableCellStyle: Font.TextStyle = .subheadline

    // MARK: - Spacing

    enum Spacing {
        // Heading 1
        static let heading1Top = Tokens.Spacing.large
        static let heading1Bottom = Tokens.Spacing.small

        // Heading 2 & 3
        static let heading2Top = Tokens.Spacing.medium
        static let heading2Bottom = Tokens.Spacing.extraSmall

        // Heading 4 & 5
        static let heading4Top = Tokens.Spacing.small
        static let heading4Bottom = Tokens.Spacing.extraExtraSmall

        // Heading 6
        static let heading6Top = Tokens.Spacing.extraSmall
        static let heading6Bottom = Tokens.Spacing.extraExtraSmall

        // Blocks
        static let paragraphBottom = Tokens.Spacing.small
        static let blockquoteLeading = Tokens.Spacing.medium
        static let blockquoteVertical = Tokens.Spacing.extraSmall
        static let codeBlockPadding = Tokens.Spacing.medium

        // Lists
        static let listItemTop = Tokens.Spacing.extraExtraSmall

        // Thematic break
        static let thematicBreakVertical = Tokens.Spacing.medium

        // Tables
        static let tableCellHorizontal = Tokens.Spacing.small
        static let tableCellVertical = Tokens.Spacing.extraSmall
    }

    // MARK: - Corner Radius

    static let codeBlockCornerRadius = Tokens.CornerRadius.small
    static let blockquoteBarCornerRadius: CGFloat = 2
    static let blockquoteBarWidth: CGFloat = 3

    // MARK: - Code Scaling

    static let inlineCodeScale: CGFloat = 0.9
    static let codeBlockScale: CGFloat = 0.85
    static let lineSpacingScale: CGFloat = 0.15
}

// MARK: - Font.TextStyle Extension

private extension Font.TextStyle {
    /// Converts SwiftUI Font.TextStyle to UIKit UIFont.TextStyle.
    var uiFontTextStyle: UIFont.TextStyle {
        switch self {
        case .largeTitle: return .largeTitle
        case .title: return .title1
        case .title2: return .title2
        case .title3: return .title3
        case .headline: return .headline
        case .subheadline: return .subheadline
        case .body: return .body
        case .callout: return .callout
        case .footnote: return .footnote
        case .caption: return .caption1
        case .caption2: return .caption2
        default: return .body
        }
    }
}

// MARK: - Dynamic Font Size Helper

/// Returns the preferred font size for a given text style, respecting Dynamic Type settings.
private func preferredFontSize(for textStyle: UIFont.TextStyle) -> CGFloat {
    UIFont.preferredFont(forTextStyle: textStyle).pointSize
}

// MARK: - Bipa MarkdownUI Theme (iOS 16-17)

public extension Theme {
    /// Bipa's custom MarkdownUI theme with default styling.
    static var bipa: Theme {
        bipa()
    }

    /// Creates a Bipa MarkdownUI theme with the specified configuration.
    /// - Parameter configuration: The style configuration to use.
    /// - Returns: A themed MarkdownUI theme.
    static func bipa(_ configuration: MarkdownStyleConfiguration = .default) -> Theme {
        Theme()

            // MARK: Text Styles

            .text {
                ForegroundColor(configuration.textColor.color)
                FontFamily(.custom(MarkdownStyleConstants.regularFont))
            }
            .code {
                FontFamilyVariant(.monospaced)
                FontSize(.em(MarkdownStyleConstants.inlineCodeScale))
                ForegroundColor(configuration.accentColor.color)
                BackgroundColor(configuration.codeBackground.color)
            }
            .emphasis {
                FontFamily(.custom(MarkdownStyleConstants.italicFont))
            }
            .strong {
                FontFamily(.custom(MarkdownStyleConstants.mediumFont))
            }
            .strikethrough {
                StrikethroughStyle(.single)
                ForegroundColor(configuration.secondaryTextColor.color)
            }
            .link {
                ForegroundColor(configuration.accentColor.color)
            }

            // MARK: Headings

            .heading1 { config in
                config.label
                    .markdownTextStyle {
                        FontFamily(.custom(MarkdownStyleConstants.mediumFont))
                        FontSize(preferredFontSize(for: MarkdownStyleConstants.heading1Style.uiFontTextStyle))
                        ForegroundColor(configuration.textColor.color)
                    }
                    .markdownMargin(top: MarkdownStyleConstants.Spacing.heading1Top, bottom: MarkdownStyleConstants.Spacing.heading1Bottom)
            }
            .heading2 { config in
                config.label
                    .markdownTextStyle {
                        FontFamily(.custom(MarkdownStyleConstants.mediumFont))
                        FontSize(preferredFontSize(for: MarkdownStyleConstants.heading2Style.uiFontTextStyle))
                        ForegroundColor(configuration.textColor.color)
                    }
                    .markdownMargin(top: MarkdownStyleConstants.Spacing.heading2Top, bottom: MarkdownStyleConstants.Spacing.heading2Bottom)
            }
            .heading3 { config in
                config.label
                    .markdownTextStyle {
                        FontFamily(.custom(MarkdownStyleConstants.mediumFont))
                        FontSize(preferredFontSize(for: MarkdownStyleConstants.heading3Style.uiFontTextStyle))
                        ForegroundColor(configuration.textColor.color)
                    }
                    .markdownMargin(top: MarkdownStyleConstants.Spacing.heading2Top, bottom: MarkdownStyleConstants.Spacing.heading2Bottom)
            }
            .heading4 { config in
                config.label
                    .markdownTextStyle {
                        FontFamily(.custom(MarkdownStyleConstants.mediumFont))
                        FontSize(preferredFontSize(for: MarkdownStyleConstants.heading4Style.uiFontTextStyle))
                        ForegroundColor(configuration.textColor.color)
                    }
                    .markdownMargin(top: MarkdownStyleConstants.Spacing.heading4Top, bottom: MarkdownStyleConstants.Spacing.heading4Bottom)
            }
            .heading5 { config in
                config.label
                    .markdownTextStyle {
                        FontFamily(.custom(MarkdownStyleConstants.mediumFont))
                        FontSize(preferredFontSize(for: MarkdownStyleConstants.heading5Style.uiFontTextStyle))
                        ForegroundColor(configuration.textColor.color)
                    }
                    .markdownMargin(top: MarkdownStyleConstants.Spacing.heading4Top, bottom: MarkdownStyleConstants.Spacing.heading4Bottom)
            }
            .heading6 { config in
                config.label
                    .markdownTextStyle {
                        FontFamily(.custom(MarkdownStyleConstants.mediumFont))
                        FontSize(preferredFontSize(for: MarkdownStyleConstants.heading6Style.uiFontTextStyle))
                        ForegroundColor(configuration.secondaryTextColor.color)
                    }
                    .markdownMargin(top: MarkdownStyleConstants.Spacing.heading6Top, bottom: MarkdownStyleConstants.Spacing.heading6Bottom)
            }

            // MARK: Blocks

            .paragraph { config in
                config.label
                    .relativeLineSpacing(.em(MarkdownStyleConstants.lineSpacingScale))
                    .markdownMargin(top: .zero, bottom: MarkdownStyleConstants.Spacing.paragraphBottom)
            }
            .blockquote { config in
                config.label
                    .markdownTextStyle {
                        FontFamily(.custom(MarkdownStyleConstants.italicFont))
                        ForegroundColor(configuration.secondaryTextColor.color)
                    }
                    .padding(.leading, MarkdownStyleConstants.Spacing.blockquoteLeading)
                    .padding(.vertical, MarkdownStyleConstants.Spacing.blockquoteVertical)
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: MarkdownStyleConstants.blockquoteBarCornerRadius)
                            .fill(configuration.accentColor.color)
                            .frame(width: MarkdownStyleConstants.blockquoteBarWidth)
                    }
                    .markdownMargin(top: MarkdownStyleConstants.Spacing.blockquoteVertical, bottom: MarkdownStyleConstants.Spacing.paragraphBottom)
            }
            .codeBlock { config in
                ScrollView(.horizontal, showsIndicators: false) {
                    config.label
                        .markdownTextStyle {
                            FontFamilyVariant(.monospaced)
                            FontSize(.em(MarkdownStyleConstants.codeBlockScale))
                        }
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(MarkdownStyleConstants.Spacing.codeBlockPadding)
                .background(configuration.codeBlockBackground.color)
                .clipShape(RoundedRectangle(cornerRadius: MarkdownStyleConstants.codeBlockCornerRadius))
                .markdownMargin(top: MarkdownStyleConstants.Spacing.blockquoteVertical, bottom: MarkdownStyleConstants.Spacing.paragraphBottom)
            }

            // MARK: Lists

            .listItem { config in
                config.label
                    .markdownMargin(top: MarkdownStyleConstants.Spacing.listItemTop)
            }
            .bulletedListMarker { _ in
                Text("•")
                    .font(.custom(MarkdownStyleConstants.regularFont, size: preferredFontSize(for: .body)))
                    .foregroundColor(configuration.accentColor.color)
            }
            .numberedListMarker { config in
                Text("\(config.itemNumber).")
                    .font(.custom(MarkdownStyleConstants.mediumFont, size: preferredFontSize(for: .body)))
                    .foregroundColor(configuration.accentColor.color)
            }

            // MARK: Thematic Break

            .thematicBreak {
                Divider()
                    .overlay(configuration.tertiaryTextColor.color)
                    .markdownMargin(top: MarkdownStyleConstants.Spacing.thematicBreakVertical, bottom: MarkdownStyleConstants.Spacing.thematicBreakVertical)
            }

            // MARK: Tables

            .table { config in
                config.label
                    .markdownTableBorderStyle(
                        .init(color: configuration.tableBorderColor.color, width: 1)
                    )
                    .markdownMargin(top: MarkdownStyleConstants.Spacing.blockquoteVertical, bottom: MarkdownStyleConstants.Spacing.paragraphBottom)
            }
            .tableCell { config in
                config.label
                    .markdownTextStyle {
                        FontFamily(.custom(MarkdownStyleConstants.regularFont))
                        FontSize(preferredFontSize(for: MarkdownStyleConstants.tableCellStyle.uiFontTextStyle))
                    }
                    .padding(.horizontal, MarkdownStyleConstants.Spacing.tableCellHorizontal)
                    .padding(.vertical, MarkdownStyleConstants.Spacing.tableCellVertical)
            }
    }
}

// MARK: - Bipa Textual Styles (iOS 18+)

@available(iOS 18.0, *)
public extension InlineStyle {
    /// Bipa's custom InlineStyle with default configuration.
    static var bipa: InlineStyle {
        bipa()
    }

    /// Creates a Bipa InlineStyle with the specified configuration.
    static func bipa(_ configuration: MarkdownStyleConfiguration = .default) -> InlineStyle {
        Bundle.ensureFontsRegistered()
        return InlineStyle()
            .code(.monospaced, .foregroundColor(configuration.accentColor.color))
            .strong(.font(.abcGinto(style: .body, weight: .medium)))
            .emphasis(.font(.abcGinto(style: .body, weight: .regular).italic()))
            .strikethrough(.strikethroughStyle(.single), .foregroundColor(configuration.secondaryTextColor.color))
            .link(.foregroundColor(configuration.accentColor.color))
    }
}

// MARK: - Bipa Heading Style

@available(iOS 18.0, *)
public extension StructuredText {
    /// Bipa's custom heading style using ABCGinto font and Apolo spacing tokens.
    struct BipaHeadingStyle: HeadingStyle {
        private let configuration: MarkdownStyleConfiguration

        public init(_ configuration: MarkdownStyleConfiguration = .default) {
            self.configuration = configuration
        }

        public func makeBody(configuration config: Configuration) -> some View {
            let level = min(config.headingLevel, 6)

            config.label
                .font(fontForLevel(level))
                .foregroundStyle(level == 6 ? configuration.secondaryTextColor.color : configuration.textColor.color)
                .textual.blockSpacing(spacingForLevel(level))
        }

        private func fontForLevel(_ level: Int) -> Font {
            switch level {
            case 1: return .abcGinto(style: MarkdownStyleConstants.heading1Style, weight: .medium)
            case 2: return .abcGinto(style: MarkdownStyleConstants.heading2Style, weight: .medium)
            case 3: return .abcGinto(style: MarkdownStyleConstants.heading3Style, weight: .medium)
            case 4: return .abcGinto(style: MarkdownStyleConstants.heading4Style, weight: .medium)
            case 5: return .abcGinto(style: MarkdownStyleConstants.heading5Style, weight: .medium)
            default: return .abcGinto(style: MarkdownStyleConstants.heading6Style, weight: .medium)
            }
        }

        private func spacingForLevel(_ level: Int) -> BlockSpacing {
            switch level {
            case 1: return .init(top: MarkdownStyleConstants.Spacing.heading1Top, bottom: MarkdownStyleConstants.Spacing.heading1Bottom)
            case 2: return .init(top: MarkdownStyleConstants.Spacing.heading2Top, bottom: MarkdownStyleConstants.Spacing.heading2Bottom)
            case 3: return .init(top: MarkdownStyleConstants.Spacing.heading2Top, bottom: MarkdownStyleConstants.Spacing.heading2Bottom)
            case 4: return .init(top: MarkdownStyleConstants.Spacing.heading4Top, bottom: MarkdownStyleConstants.Spacing.heading4Bottom)
            case 5: return .init(top: MarkdownStyleConstants.Spacing.heading4Top, bottom: MarkdownStyleConstants.Spacing.heading4Bottom)
            default: return .init(top: MarkdownStyleConstants.Spacing.heading6Top, bottom: MarkdownStyleConstants.Spacing.heading6Bottom)
            }
        }
    }
}

@available(iOS 18.0, *)
public extension StructuredText.HeadingStyle where Self == StructuredText.BipaHeadingStyle {
    static var bipa: Self { .init() }
    static func bipa(_ configuration: MarkdownStyleConfiguration) -> Self { .init(configuration) }
}

// MARK: - Bipa Paragraph Style

@available(iOS 18.0, *)
public extension StructuredText {
    /// Bipa's custom paragraph style with Apolo spacing tokens.
    struct BipaParagraphStyle: ParagraphStyle {
        public init() {}

        public func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .textual.lineSpacing(.fontScaled(MarkdownStyleConstants.lineSpacingScale))
                .textual.blockSpacing(.init(top: 0, bottom: MarkdownStyleConstants.Spacing.paragraphBottom))
        }
    }
}

@available(iOS 18.0, *)
public extension StructuredText.ParagraphStyle where Self == StructuredText.BipaParagraphStyle {
    static var bipa: Self { .init() }
}

// MARK: - Bipa BlockQuote Style

@available(iOS 18.0, *)
public extension StructuredText {
    /// Bipa's custom blockquote style with accent bar.
    struct BipaBlockQuoteStyle: BlockQuoteStyle {
        private let configuration: MarkdownStyleConfiguration

        public init(_ configuration: MarkdownStyleConfiguration = .default) {
            self.configuration = configuration
        }

        public func makeBody(configuration config: Configuration) -> some View {
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: MarkdownStyleConstants.blockquoteBarCornerRadius)
                    .fill(configuration.accentColor.color)
                    .frame(width: MarkdownStyleConstants.blockquoteBarWidth)
                config.label
                    .font(.abcGinto(style: .body, weight: .regular).italic())
                    .foregroundStyle(configuration.secondaryTextColor.color)
                    .padding(.leading, MarkdownStyleConstants.Spacing.blockquoteLeading)
            }
            .padding(.vertical, MarkdownStyleConstants.Spacing.blockquoteVertical)
            .textual.blockSpacing(.init(top: MarkdownStyleConstants.Spacing.blockquoteVertical, bottom: MarkdownStyleConstants.Spacing.paragraphBottom))
        }
    }
}

@available(iOS 18.0, *)
public extension StructuredText.BlockQuoteStyle where Self == StructuredText.BipaBlockQuoteStyle {
    static var bipa: Self { .init() }
    static func bipa(_ configuration: MarkdownStyleConfiguration) -> Self { .init(configuration) }
}

// MARK: - Bipa CodeBlock Style

@available(iOS 18.0, *)
public extension StructuredText {
    /// Bipa's custom code block style with secondary background and rounded corners.
    struct BipaCodeBlockStyle: CodeBlockStyle {
        private let configuration: MarkdownStyleConfiguration

        public init(_ configuration: MarkdownStyleConfiguration = .default) {
            self.configuration = configuration
        }

        public func makeBody(configuration config: Configuration) -> some View {
            Overflow {
                config.label
                    .textual.lineSpacing(.fontScaled(MarkdownStyleConstants.lineSpacingScale))
                    .textual.fontScale(MarkdownStyleConstants.codeBlockScale)
                    .fixedSize(horizontal: false, vertical: true)
                    .monospaced()
                    .padding(MarkdownStyleConstants.Spacing.codeBlockPadding)
            }
            .background(configuration.codeBlockBackground.color)
            .clipShape(RoundedRectangle(cornerRadius: MarkdownStyleConstants.codeBlockCornerRadius))
            .textual.blockSpacing(.init(top: MarkdownStyleConstants.Spacing.blockquoteVertical, bottom: MarkdownStyleConstants.Spacing.paragraphBottom))
        }
    }
}

@available(iOS 18.0, *)
public extension StructuredText.CodeBlockStyle where Self == StructuredText.BipaCodeBlockStyle {
    static var bipa: Self { .init() }
    static func bipa(_ configuration: MarkdownStyleConfiguration) -> Self { .init(configuration) }
}

// MARK: - Bipa ListItem Style

@available(iOS 18.0, *)
public extension StructuredText {
    /// Bipa's custom list item style with proper spacing.
    struct BipaListItemStyle: ListItemStyle {
        private let configuration: MarkdownStyleConfiguration

        public init(_ configuration: MarkdownStyleConfiguration = .default) {
            self.configuration = configuration
        }

        public func makeBody(configuration config: Configuration) -> some View {
            HStack(alignment: .firstTextBaseline, spacing: MarkdownStyleConstants.Spacing.listItemTop) {
                config.marker
                    .foregroundStyle(configuration.accentColor.color)
                config.block
            }
        }
    }
}

@available(iOS 18.0, *)
public extension StructuredText.ListItemStyle where Self == StructuredText.BipaListItemStyle {
    static var bipa: Self { .init() }
    static func bipa(_ configuration: MarkdownStyleConfiguration) -> Self { .init(configuration) }
}

// MARK: - Bipa ThematicBreak Style

@available(iOS 18.0, *)
public extension StructuredText {
    /// Bipa's custom thematic break (horizontal rule) style.
    struct BipaThematicBreakStyle: ThematicBreakStyle {
        private let configuration: MarkdownStyleConfiguration

        public init(_ configuration: MarkdownStyleConfiguration = .default) {
            self.configuration = configuration
        }

        public func makeBody(configuration _: Configuration) -> some View {
            Divider()
                .frame(minHeight: 1)
                .overlay(configuration.tertiaryTextColor.color)
                .textual.blockSpacing(.init(top: MarkdownStyleConstants.Spacing.thematicBreakVertical, bottom: MarkdownStyleConstants.Spacing.thematicBreakVertical))
        }
    }
}

@available(iOS 18.0, *)
public extension StructuredText.ThematicBreakStyle where Self == StructuredText.BipaThematicBreakStyle {
    static var bipa: Self { .init() }
    static func bipa(_ configuration: MarkdownStyleConfiguration) -> Self { .init(configuration) }
}

// MARK: - Bipa Table Style

@available(iOS 18.0, *)
public extension StructuredText {
    /// Bipa's custom table style with subtle borders.
    struct BipaTableStyle: TableStyle {
        private let configuration: MarkdownStyleConfiguration

        public init(_ configuration: MarkdownStyleConfiguration = .default) {
            self.configuration = configuration
        }

        public func makeBody(configuration config: Configuration) -> some View {
            config.label
                .textual.tableCellSpacing(horizontal: 1, vertical: 1)
                .textual.blockSpacing(.init(top: MarkdownStyleConstants.Spacing.blockquoteVertical, bottom: MarkdownStyleConstants.Spacing.paragraphBottom))
                .textual.tableBackground { layout in
                    Canvas { context, _ in
                        for bounds in layout.rowIndices.dropFirst().filter({ $0.isMultiple(of: 2) }).map({ layout.rowBounds($0) }) {
                            context.fill(
                                Path(bounds.integral),
                                with: .style(configuration.codeBackground.color)
                            )
                        }
                    }
                }
                .textual.tableOverlay { layout in
                    Canvas { context, _ in
                        for divider in layout.dividers() {
                            context.fill(
                                Path(divider),
                                with: .style(configuration.tableBorderColor.color)
                            )
                        }
                    }
                }
                .padding(1)
                .background(configuration.tableBorderColor.color)
                .clipShape(RoundedRectangle(cornerRadius: MarkdownStyleConstants.codeBlockCornerRadius))
        }
    }
}

@available(iOS 18.0, *)
public extension StructuredText.TableStyle where Self == StructuredText.BipaTableStyle {
    static var bipa: Self { .init() }
    static func bipa(_ configuration: MarkdownStyleConfiguration) -> Self { .init(configuration) }
}

// MARK: - Bipa TableCell Style

@available(iOS 18.0, *)
public extension StructuredText {
    /// Bipa's custom table cell style.
    struct BipaTableCellStyle: TableCellStyle {
        public init() {}

        public func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.abcGinto(style: MarkdownStyleConstants.tableCellStyle, weight: .regular))
                .padding(.horizontal, MarkdownStyleConstants.Spacing.tableCellHorizontal)
                .padding(.vertical, MarkdownStyleConstants.Spacing.tableCellVertical)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

@available(iOS 18.0, *)
public extension StructuredText.TableCellStyle where Self == StructuredText.BipaTableCellStyle {
    static var bipa: Self { .init() }
}

// MARK: - Bipa Complete Style

@available(iOS 18.0, *)
public extension StructuredText {
    /// Bipa's complete custom style for StructuredText using all Apolo design tokens.
    struct BipaStyle: Style {
        public let inlineStyle: InlineStyle
        public let headingStyle: BipaHeadingStyle
        public let paragraphStyle: BipaParagraphStyle
        public let blockQuoteStyle: BipaBlockQuoteStyle
        public let codeBlockStyle: BipaCodeBlockStyle
        public let listItemStyle: BipaListItemStyle
        public let unorderedListMarker: SymbolListMarker = .disc
        public let orderedListMarker: DecimalListMarker = .decimal
        public let tableStyle: BipaTableStyle
        public let tableCellStyle: BipaTableCellStyle
        public let thematicBreakStyle: BipaThematicBreakStyle

        public init(_ configuration: MarkdownStyleConfiguration = .default) {
            Bundle.ensureFontsRegistered()
            self.inlineStyle = .bipa(configuration)
            self.headingStyle = .bipa(configuration)
            self.paragraphStyle = .bipa
            self.blockQuoteStyle = .bipa(configuration)
            self.codeBlockStyle = .bipa(configuration)
            self.listItemStyle = .bipa(configuration)
            self.tableStyle = .bipa(configuration)
            self.tableCellStyle = .bipa
            self.thematicBreakStyle = .bipa(configuration)
        }
    }
}

@available(iOS 18.0, *)
public extension StructuredText.Style where Self == StructuredText.BipaStyle {
    /// Bipa's structured text style with default configuration.
    static var bipa: Self {
        .init()
    }

    /// Bipa's structured text style with custom configuration.
    static func bipa(_ configuration: MarkdownStyleConfiguration) -> Self {
        .init(configuration)
    }
}
