// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Peek",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "Peek", targets: ["Peek"])
    ],
    targets: [
        .target(name: "Peek", dependencies: []),
        .testTarget(name: "PeekTests", dependencies: ["Peek"])
    ]
)
