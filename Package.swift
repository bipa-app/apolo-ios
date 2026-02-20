// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Apolo",
    defaultLocalization: "pt-BR",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Apolo",
            targets: ["Apolo"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/gonzalezreal/swift-markdown-ui", from: "2.4.1"),
        .package(url: "https://github.com/bipa-app/textual", from: "1.0.1")
    ],
    targets: [
        .target(
            name: "Apolo",
            dependencies: [
                .product(name: "MarkdownUI", package: "swift-markdown-ui"),
                .product(name: "Textual", package: "textual")
            ],
            path: "Sources/Apolo",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
