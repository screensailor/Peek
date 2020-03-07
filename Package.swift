// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Peek",
    products: [
        .library(name: "Peek", targets: ["Peek"])
    ],
    targets: [
        .target(name: "Peek", dependencies: []),
        .testTarget(name: "PeekTests", dependencies: ["Peek"])
    ]
)
