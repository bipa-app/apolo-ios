# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Apolo is Bipa's Design System - a Swift Package providing a robust foundation of components, tokens, and patterns that ensure a cohesive user experience across all Bipa applications. Built with SwiftUI, it provides typography, colors, spacing, components, and visual effects used throughout the Bipa iOS app.

## Package Structure

```
Sources/Apolo/
├── Apolo.swift                    # Main entry point
├── Tokens/                        # Design tokens
│   ├── Tokens.swift              # Spacing and CornerRadius
│   ├── Color/                    # Color definitions and assets
│   │   ├── Colors.swift
│   │   └── Colors.xcassets/
│   └── Typography/               # Font and text style definitions
│       ├── Typography.swift      # Font families, text styles, View modifiers
│       ├── Iconography.swift     # SF Symbol sizing modifiers
│       └── Emoji.swift           # Noto Emoji support
├── Components/                   # UI Components
│   ├── Atoms/                    # Basic building blocks
│   │   ├── Buttons/             # Button styles and modifiers
│   │   ├── Tags/                # Tag components (Plain, Card, Premium, Turbo)
│   │   ├── Checkbox.swift
│   │   ├── CardBackground.swift
│   │   └── Separator.swift
│   ├── Organisms/               # Complex components
│   └── Loading.swift            # Loading indicator
├── Effects/                     # Visual effects
│   └── FlowEffect.swift
├── Modifiers/                   # View modifiers
│   └── AnimatedRadialGradientModifier.swift
├── Extensions/                  # Swift extensions
│   └── Foundation/
│       ├── Color+Ext.swift
│       └── Task+Ext.swift
└── Resources/                   # Bundled resources
    └── Fonts/                   # Custom font files
        ├── ABCGinto/           # Primary brand font
        ├── Bradford/           # Secondary serif font
        └── NotoEmoji/          # Emoji font
```

## Build & Development

### Requirements
- iOS 16.0+ (iOS 26+ for glass effects)
- Swift 5.9+
- Xcode 26+

### Building
```bash
# Build the package
swift build

# Run tests
swift test

# Open in Xcode
open Package.swift
```

### Integration
Add to your project's `Package.swift`:
```swift
dependencies: [
    .package(url: "https://github.com/ApolloAppBipa/apolo-ios.git", from: "1.0.0")
]
```

Or add via Xcode: File → Add Package Dependencies

## Design Tokens

### Spacing (`Tokens.Spacing`)
```swift
Tokens.Spacing.zero              // 0
Tokens.Spacing.extraExtraSmall   // 4
Tokens.Spacing.extraSmall        // 8
Tokens.Spacing.small             // 12
Tokens.Spacing.medium            // 16
Tokens.Spacing.large             // 20
Tokens.Spacing.extraLarge        // 32
Tokens.Spacing.extraExtraLarge   // 40
```

### Corner Radius (`Tokens.CornerRadius`)
```swift
Tokens.CornerRadius.zero         // 0
Tokens.CornerRadius.small        // 8
Tokens.CornerRadius.medium       // 12
Tokens.CornerRadius.large        // 20
```

### Colors (`Tokens.Color`)
```swift
// Custom brand colors
Tokens.Color.violet.color
Tokens.Color.rose.color

// Semantic colors (adapt to light/dark mode)
Tokens.Color.label.color
Tokens.Color.secondaryLabel.color
Tokens.Color.systemBackground.color
Tokens.Color.secondarySystemBackground.color

// System colors
Tokens.Color.blue.color
Tokens.Color.green.color
Tokens.Color.yellow.color
Tokens.Color.red.color
```

## Typography

### Font Families
- **ABCGinto** - Primary brand font (Regular, Medium, Bold, Italic variants)
- **Bradford** - Secondary serif font for editorial content
- **NotoEmoji** - Emoji rendering

### Text Styles (View Modifiers)

Apply typography to any View:
```swift
Text("Hello")
    .megaLargeTitle()      // 80pt, Medium
    .extremelyLargeTitle() // 80pt, Bold
    .superLargeTitle()     // 60pt, Bold
    .extraLargeTitle()     // 44pt, Bold
    .extraLargeTitle2()    // 36pt, Bold
    .largeTitle()          // 34pt, Medium
    .title1()              // 28pt, Medium
    .title2()              // 22pt, Medium
    .title3()              // 20pt, Bold
    .headline()            // 17pt, Medium
    .body()                // 17pt, Regular
    .callout()             // 16pt, Medium
    .subheadline()         // 15pt, Regular
    .footnote()            // 13pt, Regular
    .caption1()            // 12pt, Regular
    .caption2()            // 11pt, Regular
```

### Font Weight Options
Most text styles accept a weight parameter:
```swift
Text("Bold Body")
    .body(weight: .bold)

Text("Medium Title")
    .title3(weight: .medium)
```

### Monospaced Digits
For numerical displays that need alignment:
```swift
Text("R$ 1.234,56")
    .superLargeTitle(monospacedDigit: true)
```

### Bradford (Serif Font)
```swift
Text("Editorial text")
    .bradford(style: .body, italic: true)
```

### Direct Font Access
```swift
// For SwiftUI Font usage
let font = Font.abcGinto(style: .body, weight: .medium)
let customFont = Font.abcGinto(size: 24, weight: .bold)
```

## Iconography (SF Symbols)

**IMPORTANT: All SF Symbols must have a size modifier applied.**

```swift
// Extra Small (11pt) - Compact UI elements
Image(systemName: "star").extraSmall()

// Small (15pt) - Secondary icons, search fields
Image(systemName: "magnifyingglass").small()

// Regular (17pt) - Default size for most icons
Image(systemName: "chevron.right").regular()

// Large (22pt) - Prominent icons, empty states
Image(systemName: "exclamationmark.triangle").large()
```

## Button Styles

### Primary Button (Bordered Prominent)
```swift
Button("Continue") { }
    .borderedProminentStyle(
        shape: .capsule,        // .capsule, .circle, .roundedRectangle
        color: .green,          // Tint color
        size: .large,           // .small, .regular, .large
        glassEnabled: true      // iOS 26+ glass effect
    )
```

### Secondary Button (Bordered)
```swift
Button("Cancel") { }
    .borderedStyle(
        shape: .capsule,
        color: .blue,
        size: .large
    )
```

### Stroked Button (Outline)
```swift
Button("Outline") { }
    .strokedStyle(
        shape: .capsule,
        tintColor: .primary,
        borderColor: .primary,
        backgroundColor: .clear,
        size: .large
    )
```

### Plain Button
```swift
Button("Plain") { }
    .plainStyle(color: .blue, size: .large)
```

### Gradient Background
```swift
Button("Gradient") { }
    .borderedProminentStyle(
        shapeStyle: LinearGradient(
            colors: [.yellow, .red],
            startPoint: .leading,
            endPoint: .trailing
        )
    )
```

### Icon-Only Buttons
```swift
Button(systemImage: "bitcoinsign.circle.fill") { }
    .borderedProminentStyle(shape: .circle, color: .orange)
```

## Components

### CardBackground (Essential)

The most frequently used component for card-style containers. Provides consistent rounded backgrounds with automatic glass effects on iOS 26+.

**As a View Modifier (Recommended):**
```swift
// Primary style (default) - secondarySystemGroupedBackground
Text("Content")
    .padding()
    .cardBackground()

// Secondary style - quaternarySystemFill
Text("Content")
    .padding()
    .cardBackground(.secondary)

// Custom color
Text("Content")
    .padding()
    .cardBackground(color: .blue)

// Custom corner radius
Text("Content")
    .padding()
    .cardBackground(cornerRadius: Tokens.CornerRadius.medium)

// Disable glass effect
Text("Content")
    .padding()
    .cardBackground(glassEnabled: false)
```

**As a View (for complex layouts):**
```swift
ZStack {
    CardBackground()  // or CardBackground(.secondary)

    VStack {
        // Content
    }
    .padding()
}
```

**Styles:**
- `.primary` - `secondarySystemGroupedBackground` (default, lighter)
- `.secondary` - `quaternarySystemFill` (darker, for nested cards)

**Common Pattern - Info Card:**
```swift
VStack(alignment: .leading, spacing: Tokens.Spacing.extraExtraSmall) {
    Text("Title")
        .callout(weight: .bold)
        .foregroundStyle(Tokens.Color.label.color)

    Text("Description text here")
        .subheadline()
        .foregroundStyle(Tokens.Color.secondaryLabel.color)
}
.padding()
.frame(maxWidth: .infinity, alignment: .leading)
.cardBackground(.secondary)
.padding(.horizontal, Tokens.Spacing.medium)
```

### Tags
```swift
// Plain tag
PlainTag(text: "New", color: .green)

// Card tag
CardTag(text: "Credit")

// Premium tag
PremiumTag()

// Turbo tag
TurboTag()
```

### Checkbox
```swift
@State var isChecked = false

Checkbox(isChecked: $isChecked) {
    Text("I agree to the terms")
}
```

### Loading
```swift
Loading()
```

### Separator
```swift
Separator()
```

## Glass Effects (iOS 26+)

Apolo includes iOS 26 glass effect support with fallbacks:
```swift
// On views
someView
    .glassEffectIfAvailable(color: .blue, isClear: false)

// On buttons (automatic with glassEnabled: true)
Button("Glass") { }
    .borderedProminentStyle(glassEnabled: true)
```

## Development Guidelines

### Adding New Components

1. **Atoms** go in `Components/Atoms/` - basic, single-purpose elements
2. **Organisms** go in `Components/Organisms/` - complex, composed elements
3. All public components should have:
   - Clear documentation comments
   - A `#Preview` block for visual testing
   - Support for light/dark mode

### Adding New Tokens

1. Add constants to appropriate file in `Tokens/`
2. Use semantic naming (e.g., `small`, `medium`, `large`)
3. Document the pixel/point values in comments

### Color Guidelines
- Use `Tokens.Color` for all colors to ensure consistency
- Custom colors go in `Colors.xcassets` with light/dark variants
- Access colors via `.color` property: `Tokens.Color.violet.color`

### Font Registration
Fonts are automatically registered on first use via `Bundle.ensureFontsRegistered()`. No manual setup required in consuming apps.

### Preview Best Practices
```swift
#Preview {
    ScrollView {
        VStack(spacing: Tokens.Spacing.medium) {
            // Component variations
        }
        .padding()
    }
}
```

## Testing

### Running Tests
```bash
swift test
```

### Visual Testing
Use Xcode Previews (`#Preview`) for visual regression testing. Each component should have comprehensive previews showing all variants and states.

## Version History

See [GitHub Releases](https://github.com/bipa-app/apolo-ios/releases) for version history and changelogs.

---

**Note**: This package is a dependency of the main Bipa iOS app. Changes here affect the entire application UI. Always test thoroughly and coordinate with the design team before making changes.
