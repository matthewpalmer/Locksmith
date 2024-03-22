// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Locksmith",
    products: [
        .library(
            name: "Locksmith",
            targets: ["Locksmith"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Locksmith",
            dependencies: [],
            path: "Source"), // Custom path for the Locksmith target source files
        .testTarget(
            name: "LocksmithTests",
            dependencies: ["Locksmith"],
            path: "Tests/LocksmithTests"), // Custom path for the LocksmithTests target source files
    ]
)
