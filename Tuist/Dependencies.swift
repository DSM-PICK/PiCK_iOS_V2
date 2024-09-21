import ProjectDescription
import ConfigurationPlugin

let dependencies = Dependencies.init(
    swiftPackageManager: SwiftPackageManagerDependencies(
        [
            // Moya
            .remote(
                url: "https://github.com/Moya/Moya.git",
                requirement: .upToNextMajor(from: "15.0.3")
            ),
            // RxSwift
            .remote(url: "https://github.com/ReactiveX/RxSwift",
                    requirement: .upToNextMajor(from: "6.7.1")),
            // SnapKit
            .remote(
                url: "https://github.com/SnapKit/SnapKit.git",
                requirement: .upToNextMajor(from: "5.0.1")
            ),
            // Then
            .remote(
                url: "https://github.com/devxoul/Then.git",
                requirement: .upToNextMajor(from: "3.0.0")
            ),
            // KeychainSwift
            .remote(
                url: "https://github.com/evgenyneu/keychain-swift.git",
                requirement: .upToNextMajor(from: "20.0.0")
            ),
            // RxFlow
            .remote(
                url: "https://github.com/RxSwiftCommunity/RxFlow.git",
                requirement: .upToNextMajor(from: "2.13.0")
            ),
            // Kingfisher
            .remote(
                url: "https://github.com/onevcat/Kingfisher.git",
                requirement: .upToNextMajor(from: "7.4.1")
            ),
            //RxGesture
            .remote(
                url: "https://github.com/RxSwiftCommunity/RxGesture",
                requirement: .upToNextMajor(from: "4.0.0")
            ),
            //Swinject
            .remote(
                url: "https://github.com/Swinject/Swinject.git",
                requirement: .upToNextMajor(from: "2.8.0")
            ),
            //Lottie
            .remote(
                url: "https://github.com/airbnb/lottie-ios",
                requirement: .upToNextMajor(from: "4.3.3")
            ),
            //SkeletonView
            .remote(
                url: "https://github.com/Juanpe/SkeletonView.git",
                requirement: .upToNextMajor(from: "1.7.0")
            ),
            //FSCalendar
            .remote(
                url: "https://github.com/WenchaoD/FSCalendar.git",
                requirement: .upToNextMajor(from: "2.8.4")
            ),
            .remote(
                url: "https://github.com/RxSwiftCommunity/RxDataSources.git",
                requirement: .upToNextMajor(from: "5.0.0")
            ),
            .remote(
                url: "https://github.com/firebase/firebase-ios-sdk.git",
                requirement: .upToNextMajor(from: "10.3.0")
            ),
            .remote(
                url: "https://github.com/daltoniam/Starscream.git",
                requirement: .upToNextMajor(from: "4.0.6")
            )
        ],
        baseSettings: .settings(
            configurations: [
                .debug(name: .stage),
                .release(name: .prod)
            ]
        )
    ),
    platforms: [.iOS]
)
