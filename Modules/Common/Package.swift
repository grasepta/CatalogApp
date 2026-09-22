// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Common",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "Common", targets: ["Common"])
    ],
    dependencies: [
        .package(url: "https://github.com/grasepta/CatalogApp-Core.git", from: "1.0.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.0.0")
    ],
    targets: [
        .target(
            name: "Common",
            dependencies: [
                .product(name: "Core", package: "CatalogApp-Core"),
                .product(name: "Kingfisher", package: "Kingfisher")
            ]
        )
    ]
)
