//
//  Typography.swift
//  Apolo
//
//  Created by Eric on 04/12/24.
//

import SwiftUI

public enum Fonts {
    static let abcGinto = "ABCGinto"
    static let notoEmoji = "NotoEmoji-Regular"
    static let bradford = "Bradford"
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

public extension Font.TextStyle {
    var size: CGFloat {
        return switch self {
        case .caption2:         11
        case .caption:          12
        case .footnote:         13
        case .subheadline:      15
        case .callout:          16
        case .body:             17
        case .headline:         17
        case .title3:           20
        case .title2:           22
        case .title:            28
        case .largeTitle:       34
        case .extraLargeTitle2: 36
        case .extraLargeTitle:  44
        @unknown default:       17
        }
    }
}

// MARK: ABCGinto

public extension Font {
    // For fixed sizes (used by TypographyModifier)
    static func abcGinto(size: CGFloat, weight: FontWeight = .regular) -> Font {
        Bundle.ensureFontsRegistered()
        return .custom("\(Fonts.abcGinto)-\(weight.fontName)", fixedSize: size)
    }

    // For dynamic text styles (used by Text extensions)
    static func abcGinto(style: Font.TextStyle, weight: FontWeight = .regular) -> Font {
        Bundle.ensureFontsRegistered()

        return .custom(
            "\(Fonts.abcGinto)-\(weight.fontName)",
            size: style.size,
            relativeTo: style // <- This enables .dynamicTypeSize() to work
        )
    }
}

// MARK: - notoEmoji

public extension Font {
    static func notoEmoji(size: CGFloat) -> Font {
        Bundle.ensureFontsRegistered()
        return .custom(Fonts.notoEmoji, fixedSize: size)
    }
}

// MARK: - Bradford

public extension Font {
    /// Fixed-size Bradford. Use `italic: true` to force the Bradford-Italic face.
    static func bradford(size: CGFloat, weight: FontWeight = .regular, italic: Bool = false) -> Font {
        Bundle.ensureFontsRegistered()
        return .custom(bradfordFaceName(weight: weight, italic: italic), fixedSize: size)
    }

    /// Dynamic Bradford relative to a `Font.TextStyle`. Use `italic: true` to force the Bradford-Italic face.
    static func bradford(style: Font.TextStyle, weight: FontWeight = .regular, italic: Bool = false) -> Font {
        Bundle.ensureFontsRegistered()
        return .custom(
            bradfordFaceName(weight: weight, italic: italic),
            size: style.size,
            relativeTo: style
        )
    }
    
    private static func bradfordFaceName(weight: FontWeight, italic: Bool) -> String {
        if italic {
            return "\(Fonts.bradford)-Italic"
        }
        return "\(Fonts.bradford)-\(weight.fontName)"
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
            .fixedSize(horizontal: false, vertical: true)
    }
}

public extension Bundle {
    static func registerFonts() {
        let fonts: [(name: String, ext: String)] = [
            ("ABCGinto-Regular", "otf"),
            ("ABCGinto-Medium", "otf"),
            ("ABCGinto-Bold", "otf"),
            ("ABCGinto-RegularItalic", "otf"),
            ("ABCGinto-MediumItalic", "otf"),
            ("ABCGinto-BoldItalic", "otf"),
            ("NotoEmoji-Regular", "ttf"),
            ("Bradford-Regular", "otf"),
            ("Bradford-Italic", "otf")
        ]

        for font in fonts {
            guard let url = Bundle.module.url(forResource: font.name, withExtension: font.ext) else {
                print("Could not find font: \(font.name)")
                continue
            }

            guard let fontDataProvider = CGDataProvider(url: url as CFURL) else {
                print("Could not create font data provider: \(font.name)")
                continue
            }

            guard let font = CGFont(fontDataProvider) else {
                print("Could not create font: \(font.name)")
                continue
            }

            var error: Unmanaged<CFError>?
            guard CTFontManagerRegisterGraphicsFont(font, &error) else {
                print("Error registering font: \(String(describing: font.name))")
                continue
            }
        }
    }

    static func ensureFontsRegistered() {
        enum FontRegistration {
            static var didRegister: Bool = {
                Bundle.registerFonts()
                return true
            }()
        }

        _ = FontRegistration.didRegister
    }
}

///  Create a new extension for View that combines font, fixedSize and maybe more modifiers in the future.
private extension View {
    func apoloFont(_ font: Font) -> some View {
        self
            .font(font)
            .fixedSize(horizontal: false, vertical: true)
    }
}

public extension View {
    
    /// Mega large title style (80/100, Medium)
    func megaLargeTitle(weight: FontWeight = .medium) -> some View {
        modifier(TypographyModifier(size: 80, lineHeight: 100, weight: weight))
    }

    /// Extremely large title style (80/80, Bold)
    func extremelyLargeTitle(weight: FontWeight = .bold) -> some View {
        modifier(TypographyModifier(size: 80, lineHeight: 80, weight: weight))
    }

    /// Super large title style (48/60, Bold)
    func superLargeTitle(weight: FontWeight = .bold) -> some View {
        modifier(TypographyModifier(size: 60, lineHeight: 60, weight: weight))
    }

    /// Extra large title style (44/55, Bold)
    func extraLargeTitle(weight: FontWeight = .bold) -> some View {
        modifier(TypographyModifier(size: 44, lineHeight: 55, weight: weight))
    }

    /// Extra large title 2 style (36/45, Bold)
    func extraLargeTitle2(weight: FontWeight = .bold) -> some View {
        modifier(TypographyModifier(size: 36, lineHeight: 45, weight: weight))
    }

    /// Large title  (34/41, Medium)
    func largeTitle(weight: FontWeight = .medium) -> some View {
        modifier(TypographyModifier(size: 34, lineHeight: 41, weight: weight))
    }

    /// Title 1 style (28/34, Bold)
    func title1(weight: FontWeight = .medium) -> some View {
        apoloFont(.abcGinto(style: .title, weight: weight))
    }

    /// Title 2 style (22/28, Bold)
    func title2(weight: FontWeight = .medium) -> some View {
        apoloFont(.abcGinto(style: .title2, weight: weight))
    }

    /// Title 3 style with weight option (20/25)
    func title3(weight: FontWeight = .bold) -> some View {
        apoloFont(.abcGinto(style: .title3, weight: weight))
    }

    /// Headline style (17/24, Medium)
    func headline() -> some View {
        apoloFont(.abcGinto(style: .headline, weight: .medium))
    }

    /// Body style with weight option (17/22)
    func body(weight: FontWeight = .regular) -> some View {
        apoloFont(.abcGinto(style: .body, weight: weight))
    }

    /// Callout style with weight option (16/21)
    func callout(weight: FontWeight = .medium) -> some View {
        apoloFont(.abcGinto(style: .callout, weight: weight))
    }

    /// Subheadline style with weight option (15/20)
    func subheadline(weight: FontWeight = .regular) -> some View {
        apoloFont(.abcGinto(style: .subheadline, weight: weight))
    }

    /// Footnote style with weight option (13/18)
    func footnote(weight: FontWeight = .regular) -> some View {
        apoloFont(.abcGinto(style: .footnote, weight: weight))
    }

    /// Caption 1 style with weight option (12/16)
    func caption1(weight: FontWeight = .regular) -> some View {
        apoloFont(.abcGinto(style: .caption, weight: weight))
    }

    /// Caption 2 style with weight option (11/13)
    func caption2(weight: FontWeight = .regular) -> some View {
        apoloFont(.abcGinto(style: .caption2, weight: weight))
    }
    
    func bradford(weight: FontWeight = .regular) -> some View {
        apoloFont(.bradford(style: .footnote, weight: weight, italic: false))
    }
    
    /// Bradford italic convenience (uses Bradford-Italic face)
    func bradford(weight: FontWeight = .regular, italic: Bool = false) -> some View {
        apoloFont(.bradford(style: .body, weight: weight, italic: italic))
    }
}

#Preview {
    ScrollView {
        VStack(alignment: .leading) {
            Text("R$ 0")
                .extremelyLargeTitle(weight: .medium)

            Text("R$ 0")
                .superLargeTitle()

            Text("Extra Large Title")
                .extraLargeTitle()

            Text("Extra Large Title 2")
                .extraLargeTitle2()

            Text("Large title")
                .largeTitle()

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
            
            Image(systemName: "bitcoinsign.circle")
                .extraLargeTitle()
            
            Text("Bradford")
                .bradford(italic: true)
        }
        .padding()
    }
}
