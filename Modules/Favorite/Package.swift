// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Favorite",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "Favorite", targets: ["Favorite"])
    ],
    dependencies: [
        .package(url: "https://github.com/grasepta/CatalogApp-Core.git", from: "1.0.0"),
        .package(path: "../Common")
    ],
    targets: [
        .target(
            name: "Favorite",
            dependencies: [
                .product(name: "Core", package: "CatalogApp-Core"),
                "Common"
            ]
        )
    ]
)
