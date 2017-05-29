import PackageDescription

let package = Package(
    name: "sample-app",
    targets: [
        Target(name: "App"),
        Target(name: "Run", dependencies: ["App"]),
    ],
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2),
        .Package(url: "https://github.com/vapor/leaf-provider.git", majorVersion: 1),
    ],
    exclude: [
        "Config",
        "Database",
        "Public",
        "Resources",
    ]
)

