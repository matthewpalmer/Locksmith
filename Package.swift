// swift-tools-version:4.0

import PackageDescription

let package = Package(
  name: "Locksmith",
  products: [
      // Products define the executables and libraries produced by a package, and make them visible to other packages.
      .library(
          name: "Locksmith",
          targets: ["Locksmith"]),
  ],
  targets: [
      // Targets are the basic building blocks of a package. A target can define a module or a test suite.
      .target(
          name: "Locksmith",
          path: "Source")
  ]
)
