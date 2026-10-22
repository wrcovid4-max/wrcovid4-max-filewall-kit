// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "LanguageKit",
    platforms: [.iOS(.v16), .watchOS(.v9)],
    products: [
        // The language list. Works on iPhone, iPad and watch.
        .library(name: "LanguageKit", targets: ["LanguageKit"]),
        // The 🌐 globe menu. iPhone and iPad only (it uses UIKit).
        .library(name: "LanguageKitUI", targets: ["LanguageKitUI"]),
    ],
    targets: [
        .target(name: "LanguageKit"),
        .target(name: "LanguageKitUI", dependencies: ["LanguageKit"]),
    ]
)
