//
//  Emoji.swift
//  Apolo
//
//  Created by Eric on 19/12/24.
//

import SwiftUI

public struct Emoji: View {
    let emoji: String
    let size: CGFloat
    let color: Color

    public init(
        _ emoji: String,
        size: CGFloat = 24,
        color: Color = .primary
    ) {
        self.emoji = emoji
        self.size = size
        self.color = color
    }

    public var body: some View {
        Text(emoji)
            .font(.notoEmoji(size: size))
            .foregroundColor(color)
    }
}

#Preview {
    VStack(spacing: 16) {
        Emoji("💸")
        Emoji("💰", size: 32, color: .red)
        Emoji("📈", size: 24, color: .yellow)
        Emoji("🎉", color: .blue)
    }
}
