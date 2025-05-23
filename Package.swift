// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "automattic-support-ios",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "automattic-support-ios",
            targets: ["automattic-support-ios"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "automattic-support-ios"),
        .executableTarget(name: "automattic-support-example"),
        .testTarget(
            name: "automattic-support-iosTests",
            dependencies: ["automattic-support-ios"]
        ),
    ]
)
