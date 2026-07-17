// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Visit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "VisitShared", targets: ["VisitShared"])
    ],
    targets: [
        .target(
            name: "VisitShared",
            path: "VisitShared"
        )
    ]
)
