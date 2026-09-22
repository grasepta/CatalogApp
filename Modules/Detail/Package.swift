// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Detail",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "Detail", targets: ["Detail"])
    ],
    dependencies: [
        .package(url: "https://github.com/grasepta/CatalogApp-Core.git", from: "1.0.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.0.0"),
        .package(path: "../Common")
    ],
    targets: [
        .target(
            name: "Detail",
            dependencies: [
                .product(name: "Core", package: "CatalogApp-Core"),
                .product(name: "Kingfisher", package: "Kingfisher"),
                "Common"
            ]
        )
    ]
)
