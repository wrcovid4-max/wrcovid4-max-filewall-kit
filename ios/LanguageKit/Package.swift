// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "LanguageKit",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "LanguageKit", targets: ["LanguageKit"]),
    ],
    targets: [
        .target(name: "LanguageKit"),
    ]
)
