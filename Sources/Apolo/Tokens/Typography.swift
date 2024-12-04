//
//  Typography.swift
//  Apolo
//
//  Created by Eric on 04/12/24.
//

import SwiftUI

public enum Fonts {
    static let abcGinto = "ABCGinto"
}

public enum FontWeight {
    case regular
    case medium
    case bold

    var fontName: String {
        switch self {
        case .regular: return "Regular"
        case .medium: return "Medium"
        case .bold: return "Bold"
        }
    }
}

public extension Font {
    static func abcGinto(size: CGFloat, weight: FontWeight) -> Font {
        .custom("(Fonts.abcGinto)-(weight.fontName)", size: size)
    }
}

public struct TypographyModifier: ViewModifier {
    let size: CGFloat
    let lineHeight: CGFloat
    let weight: FontWeight

    public func body(content: Content) -> some View {
        content
            .font(.abcGinto(size: size, weight: weight))
            .lineSpacing(lineHeight - size)
    }
}

public extension Bundle {
    static func registerFonts() {
        let fonts = [
            "ABCGinto-Regular",
            "ABCGinto-Medium",
            "ABCGinto-Bold"
        ]

        for fontName in fonts {
            guard let url = Bundle.module.url(forResource: fontName, withExtension: "ttf") else {
                print("Could not find font: \(fontName)")
                continue
            }

            guard let fontDataProvider = CGDataProvider(url: url as CFURL) else {
                print("Could not create font data provider: \(fontName)")
                continue
            }

            guard let font = CGFont(fontDataProvider) else {
                print("Could not create font: \(fontName)")
                continue
            }

            var error: Unmanaged<CFError>?
            guard CTFontManagerRegisterGraphicsFont(font, &error) else {
                print("Error registering font: \(fontName)")
                continue
            }
        }
    }
}

public extension Text {
    /// Super large title style (48/60, Bold)
    func superLargeTitle() -> some View {
        modifier(TypographyModifier(size: 48, lineHeight: 60, weight: .bold))
    }

    /// Extra large title style (44/55, Bold)
    func extraLargeTitle() -> some View {
        modifier(TypographyModifier(size: 44, lineHeight: 55, weight: .bold))
    }

    /// Extra large title 2 style (36/45, Bold)
    func extraLargeTitle2() -> some View {
        modifier(TypographyModifier(size: 36, lineHeight: 45, weight: .bold))
    }

    /// Title 1 style (28/34, Bold)
    func title1() -> some View {
        modifier(TypographyModifier(size: 28, lineHeight: 34, weight: .bold))
    }

    /// Title 2 style (36/45, Bold)
    func title2() -> some View {
        modifier(TypographyModifier(size: 36, lineHeight: 45, weight: .bold))
    }

    /// Title 3 style with weight option (36/45)
    func title3(weight: FontWeight = .bold) -> some View {
        modifier(TypographyModifier(size: 36, lineHeight: 45, weight: weight))
    }

    /// Headline style (17/24, Medium)
    func headline() -> some View {
        modifier(TypographyModifier(size: 17, lineHeight: 24, weight: .medium))
    }

    /// Body style with weight option (17/22)
    func body(weight: FontWeight = .regular) -> some View {
        modifier(TypographyModifier(size: 17, lineHeight: 22, weight: weight))
    }

    /// Callout style with weight option (16/21)
    func callout(weight: FontWeight = .regular) -> some View {
        modifier(TypographyModifier(size: 16, lineHeight: 21, weight: weight))
    }

    /// Subheadline style with weight option (15/20)
    func subheadline(weight: FontWeight = .regular) -> some View {
        modifier(TypographyModifier(size: 15, lineHeight: 20, weight: weight))
    }

    /// Footnote style with weight option (13/18)
    func footnote(weight: FontWeight = .regular) -> some View {
        modifier(TypographyModifier(size: 13, lineHeight: 18, weight: weight))
    }

    /// Caption 1 style with weight option (12/16)
    func caption1(weight: FontWeight = .regular) -> some View {
        modifier(TypographyModifier(size: 12, lineHeight: 16, weight: weight))
    }

    /// Caption 2 style with weight option (11/13)
    func caption2(weight: FontWeight = .regular) -> some View {
        modifier(TypographyModifier(size: 11, lineHeight: 13, weight: weight))
    }
}

#Preview {
    Text("Hello, Satoshi!")
        .superLargeTitle()
}
