
import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "MenuBarThirdPartyLib",
    destination: .macOS,
    product: .staticFramework,
    deploymentTarget: .macOS("13.0"),
    dependencies: [
        .PackageType.SnapKit,
        .PackageType.Then,
        .PackageType.Moya,
        .PackageType.KeychainSwift
    ]
)
