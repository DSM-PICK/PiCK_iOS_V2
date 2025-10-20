
import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "MenuBarDesignSystem",
    destination: .macOS,
    product: .framework,
    deploymentTarget: .macOS("13.0"),
    dependencies: [
        .MenuBarModule.menuBarThirdPartyLib
    ]
)
