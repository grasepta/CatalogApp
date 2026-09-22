// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "About",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "About", targets: ["About"])
    ],
    targets: [
        .target(name: "About")
    ]
)
