import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "WatchThirdPartyLib",
    destination: .watchOS,
    product: .staticFramework,
    deploymentTarget: .watchOS("9.0"),
    dependencies: [
        .PackageType.RxSwift,
        .PackageType.RxCocoa,
        .PackageType.Kingfisher,
        .PackageType.Moya,
        .PackageType.RxMoya,
        .PackageType.KeychainSwift
    ]
)
