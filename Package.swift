// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Apolo",
    defaultLocalization: "pt-BR",
    platforms: [
        .iOS(.v16),
        .watchOS(.v10)
    ],
    products: [
        .library(
            name: "Apolo",
            targets: ["Apolo"]
        ),
        .library(
            name: "ApoloWidget",
            targets: ["ApoloWidget"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/gonzalezreal/swift-markdown-ui", from: "2.4.1"),
        .package(url: "https://github.com/bipa-app/textual", from: "1.0.1"),
        .package(url: "https://github.com/bipa-app/swiftui-json-render.git", from: "0.2.1")
    ],
    targets: [
        .target(
            name: "ApoloWidget",
            path: "Sources/ApoloWidget",
            resources: [
                .process("Resources"),
                .process("Colors.xcassets")
            ]
        ),
        .target(
            name: "Apolo",
            dependencies: [
                "ApoloWidget",
                .product(name: "MarkdownUI", package: "swift-markdown-ui", condition: .when(platforms: [.iOS])),
                .product(name: "Textual", package: "textual", condition: .when(platforms: [.iOS])),
                .product(name: "SwiftUIJSONRender", package: "swiftui-json-render", condition: .when(platforms: [.iOS]))
            ],
            path: "Sources/Apolo",
            resources: [
                .process("Resources"),
                .process("Colors.xcassets")
            ],
            swiftSettings: [
            ]
        )
    ]
)
