
import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "MenuBarNetwork",
    destination: .macOS,
    product: .staticFramework,
    deploymentTarget: .macOS("13.0"),
    dependencies: [
        .MenuBarModule.menuBarThirdPartyLib
    ]
)
