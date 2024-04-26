import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "AppNetwork",
    platform: .iOS,
    product: .framework,
    dependencies: [
        .Projects.core
    ]
)
