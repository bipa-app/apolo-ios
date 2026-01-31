import MarkdownUI
import SwiftUI
import Textual

// MARK: - MarkdownText

/// A markdown text component that conditionally renders using Textual (iOS 18+) or MarkdownUI (iOS 16-17).
///
/// Both renderers use Bipa's custom styling with ABCGinto font and Apolo design tokens.
///
/// - iOS 18+: Uses Textual's `StructuredText` with `BipaStyle`
/// - iOS 16-17: Uses MarkdownUI's `Markdown` with `Theme.bipa`
///
/// ## Usage
///
/// ```swift
/// // Default styling
/// MarkdownText("# Hello World")
///
/// // Secondary (muted) styling
/// MarkdownText("# Hello World", style: .secondary)
///
/// // Custom configuration
/// MarkdownText("# Hello World", style: .init(textColor: .tertiaryLabel))
/// ```
public struct MarkdownText: View {
    // MARK: - Properties

    private let content: String
    private let style: MarkdownStyleConfiguration

    // MARK: - Initialization

    /// Creates a markdown text view with the specified style configuration.
    /// - Parameters:
    ///   - content: The markdown string to render.
    ///   - style: The style configuration to use. Defaults to `.default`.
    public init(_ content: String, style: MarkdownStyleConfiguration = .default) {
        self.content = content
        self.style = style
    }

    // MARK: - Body

    public var body: some View {
        if #available(iOS 18.0, *) {
            StructuredText(markdown: content)
                .font(.abcGinto(style: .body))
                .foregroundStyle(style.textColor.color)
                .textual.structuredTextStyle(.bipa(style))
        } else {
            Markdown(content)
                .markdownTheme(.bipa(style))
        }
    }
}

// MARK: - Preview

#Preview("Default Style") {
    ScrollView {
        VStack(alignment: .leading, spacing: Tokens.Spacing.medium) {
            MarkdownText("# Default Style")
            MarkdownText("This is **bold** and *italic* text with `inline code`.")
            MarkdownText("""
            - Item one
            - Item two
            - Item three
            """)
        }
        .padding()
    }
}

#Preview("Secondary Style") {
    ScrollView {
        VStack(alignment: .leading, spacing: Tokens.Spacing.medium) {
            MarkdownText("# Secondary Style", style: .secondary)
            MarkdownText("This is **bold** and *italic* text with `inline code`.", style: .secondary)
            MarkdownText("""
            - Item one
            - Item two
            - Item three
            """, style: .secondary)
        }
        .padding()
    }
}

#Preview("All Elements") {
    ScrollView {
        VStack(alignment: .leading, spacing: Tokens.Spacing.medium) {
            // Headings
            MarkdownText("# Heading 1")
            MarkdownText("## Heading 2")
            MarkdownText("### Heading 3")
            MarkdownText("#### Heading 4")
            MarkdownText("##### Heading 5")
            MarkdownText("###### Heading 6")

            // Text styles
            MarkdownText("This is **bold** and *italic* text.")
            MarkdownText("This is ~~strikethrough~~ text.")
            MarkdownText("Here is some `inline code` in a sentence.")
            MarkdownText("Here is a [link](https://example.com).")

            // Unordered list
            MarkdownText("""
            ## Unordered List
            - Item one
            - Item two
            - Item three
            """)

            // Ordered list
            MarkdownText("""
            ## Ordered List
            1. First item
            2. Second item
            3. Third item
            """)

            // Blockquote
            MarkdownText("""
            > This is a blockquote with some
            > important information.
            """)

            // Thematic break
            MarkdownText("""
            Some text above

            ---

            Some text below
            """)

            // Code block
            MarkdownText("""
            ```swift
            let greeting = "Hello, World!"
            print(greeting)
            ```
            """)

            // Table
            MarkdownText("""
            | Feature | Status |
            |---------|--------|
            | iOS 18  | ✓      |
            | iOS 17  | ✓      |
            | iOS 16  | ✓      |
            """)
        }
        .padding()
    }
}
