import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "ThirdPartyLib",
    product: .staticFramework,
    packages: [.Firebase],
    dependencies: [
        .PackageType.SnapKit,
        .PackageType.Then,
        .PackageType.RxFlow,
        .PackageType.RxSwift,
        .PackageType.RxCocoa,
        .PackageType.KeychainSwift,
        .PackageType.Kingfisher,
        .PackageType.Moya,
        .PackageType.RxMoya,
        .PackageType.RxGesture,
        .PackageType.Swinject,
        .PackageType.Lottie,
        .PackageType.FSCalendar,
        .PackageType.RxDataSources,
        .PackageType.ReactorKit,
        .PackageType.Starscream,
        .PackageType.GoogleSignIn,
        .PackageType.FCM,
        .PackageType.Quick,
        .PackageType.FirebaseAnalytics,
        .PackageType.FirebaseSupport,
        .PackageType.FirebaseCrashlytics,
        .PackageType.FirebasePerformance
    ]
)
