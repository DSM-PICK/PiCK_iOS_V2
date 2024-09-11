import ProjectDescription

public extension TargetDependency {
    struct SPM {}
}

public extension TargetDependency.SPM {
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
    static let FCM = TargetDependency.package(product: "FirebaseMessaging")
}

public extension Package {
    static let FCM = Package.remote(url: "https://github.com/firebase/firebase-ios-sdk", requirement: .upToNextMajor(from: "10.0.0"))
}

