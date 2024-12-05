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
    targets: [
        .target(
            name: "Apolo",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
