// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "ELDER-MARX-POSTEGRES-RENDER",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "Run",
            targets: ["Run"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/vapor/vapor.git",
            from: "4.101.0"
        ),
        .package(
            url: "https://github.com/vapor/fluent.git",
            from: "4.10.0"
        ),
        .package(
            url: "https://github.com/vapor/fluent-postgres-driver.git",
            from: "2.8.0"
        )
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(
                    name: "FluentPostgresDriver",
                    package: "fluent-postgres-driver"
                )
            ],
            path: "Sources/App"
        ),
        .executableTarget(
            name: "Run",
            dependencies: [
                .target(name: "App")
            ],
            path: "Sources/Run"
        )
    ]
)
