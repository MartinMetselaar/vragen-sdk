// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "vragen-sdk",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "VragenSDK", targets: ["VragenSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/MartinMetselaar/vragen-sdk-network.git", from: "1.2.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.1"),
    ],
    targets: [
        .target(name: "VragenSDK", dependencies: [
            .product(name: "VragenSDKNetwork", package: "vragen-sdk-network"),
            .product(name: "SnapKit", package: "SnapKit")
        ], path: "./Sources", resources: [
            .process("Resources")
        ]),

        .testTarget(name: "VragenSDKTests", dependencies: [
            .target(name: "VragenSDK"),
        ]),
    ]
)
