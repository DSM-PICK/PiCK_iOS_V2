import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "AppNetwork",
    platform: .iOS,
    product: .staticFramework,
    dependencies: [
        .Projects.core
    ]
)
