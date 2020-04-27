// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Peek",
    products: [
        .library(name: "Peek", targets: ["Peek"])
    ],
    targets: [
        .target(name: "Peek"),
        .testTarget(name: "PeekTests", dependencies: ["Peek"]),
    ]
)
