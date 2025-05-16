//
//  Typography.swift
//  Apolo
//
//  Created by Eric on 04/12/24.
//

import CoreText
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
        
        let fontName = "\(Fonts.abcGinto)-\(weight.fontName)" as CFString
        let font = CTFontCreateWithName(fontName, size, nil)
        
        // Disable Contextual Alternates (this controls the automatic substitution of x between numbers)
        let featureSettings: [[CFString: Any]] = [
            [
                kCTFontFeatureTypeIdentifierKey: 36,    // Contextual Alternates
                kCTFontFeatureSelectorIdentifierKey: 1, // Off
            ]
        ]
        
        let attributes = [
            kCTFontFeatureSettingsAttribute: featureSettings,
            kCTFontSizeAttribute: size,
        ] as CFDictionary
        
        let descriptor = CTFontDescriptorCreateWithAttributes(attributes)
        let modifiedFont = CTFontCreateCopyWithAttributes(
            font, size, nil, descriptor)

        return Font(modifiedFont)
    }

    // For dynamic text styles (used by Text extensions)
    static func abcGinto(
        style: Font.TextStyle,
        weight: FontWeight = .regular
    ) -> Font {
        Bundle.ensureFontsRegistered()

        let size = style.size
        let fontName = "\(Fonts.abcGinto)-\(weight.fontName)" as CFString
        let font = CTFontCreateWithName(fontName, size, nil)

        // Disable Contextual Alternates (this controls the automatic substitution of x between numbers)
        let featureSettings: [[CFString: Any]] = [
            [
                kCTFontFeatureTypeIdentifierKey: 36,     // Contextual Alternates
                kCTFontFeatureSelectorIdentifierKey: 1,   // Off
            ]
        ]
        
        let attributes = [
            kCTFontFeatureSettingsAttribute: featureSettings,
            kCTFontSizeAttribute: size,
        ] as CFDictionary
        
        let descriptor = CTFontDescriptorCreateWithAttributes(attributes)
        let modifiedFont = CTFontCreateCopyWithAttributes(
            font, size, nil, descriptor)

        return Font(modifiedFont)
    }
}

public extension Font.TextStyle {
    var size: CGFloat {
        switch self {
        case .largeTitle:
            return 34
        case .title:
            return 28
        case .title2:
            return 22
        case .title3:
            return 20
        case .headline:
            return 17
        case .subheadline:
            return 15
        case .body:
            return 17
        case .callout:
            return 16
        case .footnote:
            return 13
        case .caption:
            return 12
        case .caption2:
            return 11
        case .extraLargeTitle:
            return 44
        case .extraLargeTitle2:
            return 36
        @unknown default:
            return 17
        }
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

public extension View {
    /// Extremely large title style (80/80, Bold)
    func extremelyLargeTitle(weight: FontWeight = .bold) -> some View {
        modifier(TypographyModifier(size: 80, lineHeight: 80, weight: weight))
            .dynamicTypeSize(...DynamicTypeSize.medium)
    }

    /// Super large title style (48/60, Bold)
    func superLargeTitle(weight: FontWeight = .bold) -> some View {
        modifier(TypographyModifier(size: 60, lineHeight: 60, weight: weight))
            .dynamicTypeSize(...DynamicTypeSize.medium)
    }

    /// Extra large title style (44/55, Bold)
    func extraLargeTitle(weight: FontWeight = .bold) -> some View {
        modifier(TypographyModifier(size: 44, lineHeight: 55, weight: weight))
            .dynamicTypeSize(...DynamicTypeSize.large)
    }

    /// Extra large title 2 style (36/45, Bold)
    func extraLargeTitle2(weight: FontWeight = .bold) -> some View {
        modifier(TypographyModifier(size: 36, lineHeight: 45, weight: weight))
            .dynamicTypeSize(...DynamicTypeSize.large)
    }

    /// Title 1 style (28/34, Bold)
    func title1(weight: FontWeight = .medium) -> some View {
        apoloFont(.abcGinto(style: .title, weight: weight))
            .dynamicTypeSize(...DynamicTypeSize.large)
    }

    /// Title 2 style (22/28, Bold)
    func title2(weight: FontWeight = .medium) -> some View {
        apoloFont(.abcGinto(style: .title2, weight: weight))
            .dynamicTypeSize(...DynamicTypeSize.large)
    }

    /// Title 3 style with weight option (20/25)
    func title3(weight: FontWeight = .bold) -> some View {
        apoloFont(.abcGinto(style: .title3, weight: weight))
            .dynamicTypeSize(...DynamicTypeSize.large)
    }

    /// Headline style (17/24, Medium)
    func headline() -> some View {
        apoloFont(.abcGinto(style: .headline, weight: .medium))
            .dynamicTypeSize(...DynamicTypeSize.xLarge)
    }

    /// Body style with weight option (17/22)
    func body(weight: FontWeight = .regular) -> some View {
        apoloFont(.abcGinto(style: .body, weight: weight))
            .dynamicTypeSize(...DynamicTypeSize.large)
    }

    /// Callout style with weight option (16/21)
    func callout(weight: FontWeight = .medium) -> some View {
        apoloFont(.abcGinto(style: .callout, weight: weight))
            .dynamicTypeSize(...DynamicTypeSize.large)
    }

    /// Subheadline style with weight option (15/20)
    func subheadline(weight: FontWeight = .regular) -> some View {
        apoloFont(.abcGinto(style: .subheadline, weight: weight))
            .dynamicTypeSize(...DynamicTypeSize.large)
    }

    /// Footnote style with weight option (13/18)
    func footnote(weight: FontWeight = .regular) -> some View {
        apoloFont(.abcGinto(style: .footnote, weight: weight))
            .dynamicTypeSize(...DynamicTypeSize.large)
    }

    /// Caption 1 style with weight option (12/16)
    func caption1(weight: FontWeight = .regular) -> some View {
        apoloFont(.abcGinto(style: .caption, weight: weight))
            .dynamicTypeSize(...DynamicTypeSize.large)
    }

    /// Caption 2 style with weight option (11/13)
    func caption2(weight: FontWeight = .regular) -> some View {
        apoloFont(.abcGinto(style: .caption2, weight: weight))
            .dynamicTypeSize(...DynamicTypeSize.large)
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

            Text("Contextual alternate: 0x0x")
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
        }
        .padding()
    }
}
