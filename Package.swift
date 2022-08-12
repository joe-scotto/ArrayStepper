// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "ArrayStepper",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "ArrayStepper",
            targets: ["ArrayStepper"]),
    ],
    targets: [
        .target(
            name: "ArrayStepper",
            dependencies: []),
    ]
)
