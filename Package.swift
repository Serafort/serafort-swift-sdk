// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Serafort",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "Serafort",
            targets: ["Serafort"]
        ),
    ],
    targets: [
        .target(
            name: "Serafort",
            path: "Sources/Serafort"
        ),
        .testTarget(
            name: "SerafortTests",
            dependencies: ["Serafort"],
            path: "Tests/SerafortTests"
        ),
    ]
)
