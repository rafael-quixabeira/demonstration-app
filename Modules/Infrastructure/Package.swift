// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Infrastructure",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Infrastructure",
            targets: ["Infrastructure"]),
    ],
    dependencies: [
        .package(path: "../ArkanaKeys"),
        .package(path: "../ArkanaKeysInterfaces")
    ],
    targets: [
        .target(
            name: "Infrastructure",
            dependencies: [
                "ArkanaKeys",
                "ArkanaKeysInterfaces"
            ])
    ]
)
