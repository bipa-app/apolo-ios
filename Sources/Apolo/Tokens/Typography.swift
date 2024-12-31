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
    // For fixed sizes (used by TypographyModifier)
    static func abcGinto(size: CGFloat, weight: FontWeight = .regular) -> Font {
        Bundle.ensureFontsRegistered()
        return .custom("\(Fonts.abcGinto)-\(weight.fontName)", fixedSize: size)
    }

    // For dynamic text styles (used by Text extensions)
    static func abcGinto(style: Font.TextStyle, weight: FontWeight = .regular) -> Font {
        Bundle.ensureFontsRegistered()

        let styledText: UIFont.TextStyle = {
            switch style {
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
        }()

        let preferredFont = UIFont.preferredFont(forTextStyle: styledText)

        return .custom("\(Fonts.abcGinto)-\(weight.fontName)", size: preferredFont.pointSize, relativeTo: style)
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
            ("NotoEmoji-Regular", "ttf")
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

public extension Font {
    static func notoEmoji(size: CGFloat) -> Font {
        Bundle.ensureFontsRegistered()
        return .custom(Fonts.notoEmoji, fixedSize: size)
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
        apoloFont(.abcGinto(style: .title, weight: .bold))
    }

    /// Title 2 style (22/28, Bold)
    func title2() -> some View {
        apoloFont(.abcGinto(style: .title2, weight: .bold))
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
    func callout(weight: FontWeight = .regular) -> some View {
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
