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
    dependencies: [
        .package(url: "https://github.com/screensailor/Hope.git", .branch("trunk")),
    ],
    targets: [
        .target(name: "Peek"),
        .testTarget(name: "PeekTests", dependencies: ["Peek", "Hope"]),
    ]
)
