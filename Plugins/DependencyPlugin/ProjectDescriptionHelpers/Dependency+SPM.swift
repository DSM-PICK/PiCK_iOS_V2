import ProjectDescription

public extension TargetDependency.PackageType {
    static let Moya = TargetDependency.external(name: "Moya")
    static let RxSwift = TargetDependency.external(name: "RxSwift")
    static let SnapKit = TargetDependency.external(name: "SnapKit")
    static let Then = TargetDependency.external(name: "Then")
    static let RxCocoa = TargetDependency.external(name: "RxCocoa")
    static let RxMoya = TargetDependency.external(name: "RxMoya")
    static let KeychainSwift = TargetDependency.external(name: "KeychainSwift")
    static let RxFlow = TargetDependency.external(name: "RxFlow")
    static let Kingfisher = TargetDependency.external(name: "Kingfisher")
    static let RxGesture = TargetDependency.external(name: "RxGesture")
    static let Swinject = TargetDependency.external(name: "Swinject")
    static let Lottie = TargetDependency.external(name: "Lottie")
    static let SkeletonView = TargetDependency.external(name: "SkeletonView")
    static let FSCalendar = TargetDependency.external(name: "FSCalendar")
    static let RxDataSources = TargetDependency.external(name: "RxDataSources")
    static let ReactorKit = TargetDependency.external(name: "ReactorKit")
    static let Starscream = TargetDependency.external(name: "Starscream")
    static let FCM = TargetDependency.external(name: "FirebaseMessaging")
    static let FirebaseAnalytics = TargetDependency.external(name: "FirebaseAnalytics")
    static let FirebaseSupport = TargetDependency.external(name: "FirebaseAnalyticsWithoutAdIdSupport")
    static let FirebaseCrashlytics = TargetDependency.external(name: "FirebaseCrashlytics")
    static let FirebasePerformance = TargetDependency.external(name: "FirebasePerformance")
}

public extension Package {
    static let Firebase = Package.remote(url: "https://github.com/firebase/firebase-ios-sdk", requirement: .upToNextMajor(from: "10.0.0"))
}

