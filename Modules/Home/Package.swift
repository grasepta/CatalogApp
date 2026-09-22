// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Home",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "Home", targets: ["Home"])
    ],
    dependencies: [
        .package(url: "https://github.com/grasepta/CatalogApp-Core.git", from: "1.0.0"),
        .package(path: "../Common")
    ],
    targets: [
        .target(
            name: "Home",
            dependencies: [
                .product(name: "Core", package: "CatalogApp-Core"),
                "Common"
            ]
        )
    ]
)
