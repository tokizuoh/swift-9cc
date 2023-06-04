// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "swift-9cc",
    products: [
        .executable(
            name: "swift-9cc",
            targets: ["swift-9cc"]
        )
    ],
    targets: [
        .executableTarget(
            name: "swift-9cc",
            dependencies: []
        ),
    ]
)
