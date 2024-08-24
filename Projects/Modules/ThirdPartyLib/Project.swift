import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "ThirdPartyLib",
    platform: .iOS,
    product: .framework,
    dependencies: [
        .SPM.SnapKit,
        .SPM.Then,
        .SPM.RxFlow,
        .SPM.RxSwift,
        .SPM.RxCocoa,
        .SPM.KeychainSwift,
        .SPM.Kingfisher,
        .SPM.Moya,
        .SPM.RxMoya,
        .SPM.RxGesture,
        .SPM.Swinject,
        .SPM.Lottie,
        .SPM.SkeletonView,
        .SPM.FSCalendar,
        .SPM.RxDataSources
    ]
)
