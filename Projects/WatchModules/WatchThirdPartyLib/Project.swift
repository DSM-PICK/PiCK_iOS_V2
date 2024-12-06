import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "WatchThirdPartyLib",
    platform: .watchOS,
    product: .staticFramework,
    deploymentTarget: .watchOS(targetVersion: "9.0"),
    dependencies: [
        .SPM.RxSwift,
        .SPM.RxCocoa,
        .SPM.Kingfisher,
        .SPM.Moya,
        .SPM.RxMoya,
        .SPM.KeychainSwift
    ]
)
