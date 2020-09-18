// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Peek",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(name: "Peek", targets: ["Peek"])
    ],
    targets: [
        .target(name: "Peek"),
        .testTarget(name: "PeekTests", dependencies: ["Peek"]),
    ]
)
