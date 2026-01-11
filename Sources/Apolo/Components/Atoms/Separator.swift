//
//  Separator.swift
//  Apolo
//
//  Created by Eric on 08/01/25.
//

import SwiftUI

/// A view that displays a horizontal line separator with customizable color.
///
/// Use `Separator` when you need to visually separate content in your interface.
/// By default, it uses the system's secondary fill color, but you can customize it
/// with any color of your choice.
///
/// Example usage:
/// ```swift
/// VStack {
///     Text("Above separator")
///     Separator()
///     Text("Below separator")
/// }
/// ```
///
/// You can also customize the color:
/// ```swift
/// Separator(color: .red)
/// ```
public struct Separator: View {
    /// The color of the separator line.
    ///
    /// Defaults to `Color(.secondarySystemFill)` if not specified.
    public let color: Color

    #if os(watchOS)
    public static let defaultColor = Color.gray.opacity(0.3)
    #else
    public static let defaultColor = Color(.secondarySystemFill)
    #endif

    /// Creates a new separator with the specified color.
    ///
    /// - Parameter color: The color to use for the separator line.
    ///   Defaults to the system's secondary fill color if not specified.
    public init(color: Color = defaultColor) {
        self.color = color
    }

    public var body: some View {
        Divider()
            .overlay(color)
    }
}

#Preview {
    VStack(spacing: 20) {
        Separator()
        Separator(color: .red)
        Separator(color: .blue)
    }
    .padding()
}
