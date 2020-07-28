// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Locksmith",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "Locksmith", targets: ["Locksmith"])
    ],
    targets: [
        .target(name: "MyLibrary", dependencies: ["Utility"]),
        .testTarget(name: "MyLibraryTests", dependencies: ["MyLibrary"])
    ]
)
