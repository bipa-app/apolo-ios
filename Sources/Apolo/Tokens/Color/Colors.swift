//
//  Colors.swift
//  Apolo
//
//  Created by Eric on 24/02/25.
//

import SwiftUI

public extension Tokens {
    enum Color: ShapeStyle {
        // MARK: - Custom Colors

        case violet
        case rose

        // MARK: - Text Colors

        case lightText
        case darkText
        case placeholderText

        // MARK: - Label Colors

        case label
        case secondaryLabel
        case tertiaryLabel
        case quaternaryLabel

        // MARK: - Background Colors

        case systemBackground
        case secondarySystemBackground
        case tertiarySystemBackground

        // MARK: - Fill Colors

        case systemFill
        case secondarySystemFill
        case tertiarySystemFill
        case quaternarySystemFill

        // MARK: - Grouped Background Colors

        case systemGroupedBackground
        case secondarySystemGroupedBackground
        case tertiarySystemGroupedBackground

        // MARK: - System Colors

        case blue
        case green
        case yellow
        case orange
        case red
        case teal
        case indigo
        case cyan
        case mint

        public var color: SwiftUI.Color {
            switch self {
                // MARK: - Custom Colors

                case .violet: return SwiftUI.Color("Violet", bundle: .module)
                case .rose: return SwiftUI.Color("Rose", bundle: .module)

                // MARK: - Text Colors

                #if os(watchOS)
                case .lightText: return SwiftUI.Color.white
                case .darkText: return SwiftUI.Color.black
                case .placeholderText: return SwiftUI.Color.gray
                #else
                case .lightText: return SwiftUI.Color(.lightText)
                case .darkText: return SwiftUI.Color(.darkText)
                case .placeholderText: return SwiftUI.Color(.placeholderText)
                #endif

                // MARK: - Label Colors

                #if os(watchOS)
                case .label: return SwiftUI.Color.primary
                case .secondaryLabel: return SwiftUI.Color.secondary
                case .tertiaryLabel: return SwiftUI.Color.secondary.opacity(0.7)
                case .quaternaryLabel: return SwiftUI.Color.secondary.opacity(0.5)
                #else
                case .label: return SwiftUI.Color(.label)
                case .secondaryLabel: return SwiftUI.Color(.secondaryLabel)
                case .tertiaryLabel: return SwiftUI.Color(.tertiaryLabel)
                case .quaternaryLabel: return SwiftUI.Color(.quaternaryLabel)
                #endif

                // MARK: - Background Colors

                #if os(watchOS)
                case .systemBackground: return SwiftUI.Color.black
                case .secondarySystemBackground: return SwiftUI.Color(white: 0.11)
                case .tertiarySystemBackground: return SwiftUI.Color(white: 0.17)
                #else
                case .systemBackground: return SwiftUI.Color(.systemBackground)
                case .secondarySystemBackground: return SwiftUI.Color(.secondarySystemBackground)
                case .tertiarySystemBackground: return SwiftUI.Color(.tertiarySystemBackground)
                #endif

                // MARK: - Fill Colors

                #if os(watchOS)
                case .systemFill: return SwiftUI.Color.gray.opacity(0.36)
                case .secondarySystemFill: return SwiftUI.Color.gray.opacity(0.32)
                case .tertiarySystemFill: return SwiftUI.Color.gray.opacity(0.24)
                case .quaternarySystemFill: return SwiftUI.Color.gray.opacity(0.18)
                #else
                case .systemFill: return SwiftUI.Color(.systemFill)
                case .secondarySystemFill: return SwiftUI.Color(.secondarySystemFill)
                case .tertiarySystemFill: return SwiftUI.Color(.tertiarySystemFill)
                case .quaternarySystemFill: return SwiftUI.Color(.quaternarySystemFill)
                #endif

                // MARK: - Grouped Background Colors

                #if os(watchOS)
                case .systemGroupedBackground: return SwiftUI.Color.black
                case .secondarySystemGroupedBackground: return SwiftUI.Color(white: 0.11)
                case .tertiarySystemGroupedBackground: return SwiftUI.Color(white: 0.17)
                #else
                case .systemGroupedBackground: return SwiftUI.Color(.systemGroupedBackground)
                case .secondarySystemGroupedBackground: return SwiftUI.Color(.secondarySystemGroupedBackground)
                case .tertiarySystemGroupedBackground: return SwiftUI.Color(.tertiarySystemGroupedBackground)
                #endif

                // MARK: - System Colors

                case .blue: return SwiftUI.Color.blue
                case .green: return SwiftUI.Color.green
                case .yellow: return SwiftUI.Color.yellow
                case .orange: return SwiftUI.Color.orange
                case .red: return SwiftUI.Color.red
                case .teal: return SwiftUI.Color.teal
                case .indigo: return SwiftUI.Color.indigo
                case .cyan: return SwiftUI.Color.cyan
                case .mint: return SwiftUI.Color.mint
            }
        }

        // MARK: - ShapeStyle Conformance

        public func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
            color
        }
    }
}

// MARK: - ColorCard

#if !os(watchOS)
private struct ColorCard: View {
    let name: String
    let color: Tokens.Color

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: Tokens.CornerRadius.medium)
                .fill(color)
                .frame(height: 60)
                .shadow(color: Tokens.Color.quaternaryLabel.color, radius: 1.5)
            Text(name)
                .caption1()
        }
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(spacing: Tokens.Spacing.medium) {
            Group {
                Text("Text Colors")
                    .headline()

                HStack {
                    ColorCard(name: "Light Text", color: Tokens.Color.lightText)
                    ColorCard(name: "Dark Text", color: Tokens.Color.darkText)
                    ColorCard(name: "Placeholder", color: Tokens.Color.placeholderText)
                }
            }

            Group {
                Text("Label Colors")
                    .headline()

                HStack {
                    ColorCard(name: "Label", color: Tokens.Color.label)
                    ColorCard(name: "Secondary", color: Tokens.Color.secondaryLabel)
                }
                HStack {
                    ColorCard(name: "Tertiary", color: Tokens.Color.tertiaryLabel)
                    ColorCard(name: "Quaternary", color: Tokens.Color.quaternaryLabel)
                }
            }

            Group {
                Text("Background Colors")
                    .headline()

                HStack {
                    ColorCard(name: "System", color: Tokens.Color.systemBackground)
                    ColorCard(name: "Secondary", color: Tokens.Color.secondarySystemBackground)
                    ColorCard(name: "Tertiary", color: Tokens.Color.tertiarySystemBackground)
                }
            }

            Group {
                Text("Fill Colors")
                    .headline()

                HStack {
                    ColorCard(name: "System", color: Tokens.Color.systemFill)
                    ColorCard(name: "Secondary", color: Tokens.Color.secondarySystemFill)
                }
                HStack {
                    ColorCard(name: "Tertiary", color: Tokens.Color.tertiarySystemFill)
                    ColorCard(name: "Quaternary", color: Tokens.Color.quaternarySystemFill)
                }
            }

            Group {
                Text("Grouped Background Colors")
                    .headline()

                HStack {
                    ColorCard(name: "System", color: Tokens.Color.systemGroupedBackground)
                    ColorCard(name: "Secondary", color: Tokens.Color.secondarySystemGroupedBackground)
                }
                ColorCard(name: "Tertiary", color: Tokens.Color.tertiarySystemGroupedBackground)
            }

            Group {
                Text("Custom Colors")
                    .headline()

                HStack {
                    ColorCard(name: "Violet", color: Tokens.Color.violet)
                    ColorCard(name: "Rose", color: Tokens.Color.rose)
                }
            }

            Group {
                Text("System Colors")
                    .headline()

                HStack {
                    ColorCard(name: "Blue", color: Tokens.Color.blue)
                    ColorCard(name: "Green", color: Tokens.Color.green)
                }
                HStack {
                    ColorCard(name: "Yellow", color: Tokens.Color.yellow)
                    ColorCard(name: "Orange", color: Tokens.Color.orange)
                }
                HStack {
                    ColorCard(name: "Red", color: Tokens.Color.red)
                    ColorCard(name: "Teal", color: Tokens.Color.teal)
                    ColorCard(name: "Indigo", color: Tokens.Color.indigo)
                }
                HStack {
                    ColorCard(name: "Cyan", color: Tokens.Color.cyan)
                    ColorCard(name: "Mint", color: Tokens.Color.mint)
                }
            }
        }
        .padding()
    }
}
#endif
