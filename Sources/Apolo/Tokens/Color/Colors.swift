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
        case purple
        case green
        case yellow
        case orange
        case pink
        case red
        case teal
        case indigo

        public var color: SwiftUI.Color {
            switch self {
                // MARK: - Custom Colors

                case .violet: return SwiftUI.Color("Violet", bundle: .module)
                case .rose: return SwiftUI.Color("Rose", bundle: .module)

                // MARK: - Text Colors

                case .lightText: return SwiftUI.Color(.lightText)
                case .darkText: return SwiftUI.Color(.darkText)
                case .placeholderText: return SwiftUI.Color(.placeholderText)

                // MARK: - Label Colors

                case .label: return SwiftUI.Color(.label)
                case .secondaryLabel: return SwiftUI.Color(.secondaryLabel)
                case .tertiaryLabel: return SwiftUI.Color(.tertiaryLabel)
                case .quaternaryLabel: return SwiftUI.Color(.quaternaryLabel)

                // MARK: - Background Colors

                case .systemBackground: return SwiftUI.Color(.systemBackground)
                case .secondarySystemBackground: return SwiftUI.Color(.secondarySystemBackground)
                case .tertiarySystemBackground: return SwiftUI.Color(.tertiarySystemBackground)

                // MARK: - Fill Colors

                case .systemFill: return SwiftUI.Color(.systemFill)
                case .secondarySystemFill: return SwiftUI.Color(.secondarySystemFill)
                case .tertiarySystemFill: return SwiftUI.Color(.tertiarySystemFill)
                case .quaternarySystemFill: return SwiftUI.Color(.quaternarySystemFill)

                // MARK: - Grouped Background Colors

                case .systemGroupedBackground: return SwiftUI.Color(.systemGroupedBackground)
                case .secondarySystemGroupedBackground: return SwiftUI.Color(.secondarySystemGroupedBackground)
                case .tertiarySystemGroupedBackground: return SwiftUI.Color(.tertiarySystemGroupedBackground)

                // MARK: - System Colors

                case .blue: return SwiftUI.Color(.systemBlue)
                case .purple: return SwiftUI.Color(.systemPurple)
                case .green: return SwiftUI.Color(.systemGreen)
                case .yellow: return SwiftUI.Color(.systemYellow)
                case .orange: return SwiftUI.Color(.systemOrange)
                case .pink: return SwiftUI.Color(.systemPink)
                case .red: return SwiftUI.Color(.systemRed)
                case .teal: return SwiftUI.Color(.systemTeal)
                case .indigo: return SwiftUI.Color(.systemIndigo)
            }
        }

        // MARK: - ShapeStyle Conformance

        public func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
            color
        }
    }
}
