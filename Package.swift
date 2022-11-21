// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Locksmith",
    products: [
        .library(
            name: "Locksmith",
            targets: ["Locksmith"]),
    ],
    targets: [
        .target(
            name: "Locksmith",
            dependencies: [],
            path: "Source"),
    ]
)
