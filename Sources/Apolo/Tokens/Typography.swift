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
        Bundle.ensureFontsRegistered()
        return .custom("\(Fonts.abcGinto)-\(weight.fontName)", size: size)
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
            guard let url = Bundle.module.url(forResource: fontName, withExtension: "otf") else {
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
    
    static func ensureFontsRegistered() {
        struct FontRegistration {
            static var didRegister: Bool = {
                Bundle.registerFonts()
                return true
            }()
        }

        _ = FontRegistration.didRegister
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
        font(.largeTitle)
            .fontWeight(.bold)
    }

    /// Title 2 style (22/28, Bold)
    func title2() -> some View {
        font(.title)
            .fontWeight(.bold)
    }

    /// Title 3 style with weight option (20/25)
    func title3(weight: FontWeight = .bold) -> some View {
        font(.title2)
            .fontWeight(weight == .bold ? .bold : weight == .medium ? .medium : .regular)
    }

    /// Headline style (17/24, Medium)
    func headline() -> some View {
        font(.headline)
    }

    /// Body style with weight option (17/22)
    func body(weight: FontWeight = .regular) -> some View {
        font(.body)
            .fontWeight(weight == .bold ? .bold : weight == .medium ? .medium : .regular)
    }

    /// Callout style with weight option (16/21)
    func callout(weight: FontWeight = .regular) -> some View {
        font(.callout)
            .fontWeight(weight == .bold ? .bold : weight == .medium ? .medium : .regular)
    }

    /// Subheadline style with weight option (15/20)
    func subheadline(weight: FontWeight = .regular) -> some View {
        font(.subheadline)
            .fontWeight(weight == .bold ? .bold : weight == .medium ? .medium : .regular)
    }

    /// Footnote style with weight option (13/18)
    func footnote(weight: FontWeight = .regular) -> some View {
        font(.footnote)
            .fontWeight(weight == .bold ? .bold : weight == .medium ? .medium : .regular)
    }

    /// Caption 1 style with weight option (12/16)
    func caption1(weight: FontWeight = .regular) -> some View {
        font(.caption)
            .fontWeight(weight == .bold ? .bold : weight == .medium ? .medium : .regular)
    }

    /// Caption 2 style with weight option (11/13)
    func caption2(weight: FontWeight = .regular) -> some View {
        font(.caption2)
            .fontWeight(weight == .bold ? .bold : weight == .medium ? .medium : .regular)
    }
}

#Preview {
    ScrollView {
        VStack(alignment: .leading) {
            Text("Super Large Title")
                .superLargeTitle()

            Text("Extra Large Title")
                .extraLargeTitle()

            Text("Extra Large Title 2")
                .extraLargeTitle2()

            Text("Title 1")
                .title1()

            Text("Title 2")
                .title2()

            Text("Title 3")
                .title3()

            Text("Headline")
                .headline()

            Text("Bitcoin has reached 100.000 USD, marking a new all-time high. This price action comes amid increased institutional adoption and strong market fundamentals.")
                .body()

            Text("Callout")
                .callout()

            Text("Subheadline")
                .subheadline()

            Text("Footnote")
                .footnote()

            Text("Caption 1")
                .caption1()

            Text("Caption 2")
                .caption2()
        }
        .padding()
    }
}
