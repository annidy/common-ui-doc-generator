// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "common-ui-doc-generator",
    products: [
        .library(
            name: "common-ui-doc-utils",
            targets: ["common-ui-doc-utils"]),
        .executable(
            name: "common-ui-doc-generator",
            targets: ["common-ui-doc-generator"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "common-ui-doc-utils",
            dependencies: []
        ),
        .executableTarget(
            name: "common-ui-doc-generator",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "common-ui-doc-utils"
            ]),
        .testTarget(
            name: "common-ui-doc-generatorTests",
            dependencies: ["common-ui-doc-generator"]),
    ]
)
