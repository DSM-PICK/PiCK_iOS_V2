// swift-tools-version:6.1

import PackageDescription

#if TUIST
    import ProjectDescription
    import ProjectDescriptionHelpers
    import EnvironmentPlugin

    let packageSettings = PackageSettings(
        productTypes: [
            "RxSwift": .framework,
            "KeychainSwift": .framework,
            "Starscream": .framework
        ],
        baseSettings: .settings(
            base: env.baseSetting,
            configurations: [
                .debug(name:  "STAGE"),
                .release(name: "PROD")
            ]
        )
    )
#endif

let package = Package(
    name: "PiCKPackage",
    platforms: [.iOS(.v16), .watchOS(.v9)],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.3"),
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "6.7.1"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.1"),
        .package(url: "https://github.com/devxoul/Then.git", from: "3.0.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.4.1"),
        .package(url: "https://github.com/RxSwiftCommunity/RxGesture", from: "4.0.0"),
        .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "24.0.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxFlow.git", from: "2.13.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxGesture", from: "4.0.0"),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0"),
        .package(url: "https://github.com/airbnb/lottie-ios", from: "4.3.3"),
        .package(url: "https://github.com/WenchaoD/FSCalendar.git", from: "2.8.4"),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", from: "5.0.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.3.0"),
        .package(url: "https://github.com/daltoniam/Starscream.git", from: "4.0.6")
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                "RxSwift",
                .product(name: "RxCocoa", package: "RxSwift"),
                "Moya",
                "RxMoya",
                "Kingfisher",
                "RxGesture",
                "KeychainSwift",
                "Swinject",
                "RxFlow",
                "Lottie",
                "FSCalendar",
                "RxDataSources",
                "Starscream",
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk")
            ]
        )
    ]
)
