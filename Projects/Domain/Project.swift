import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Domain",
    platform: .iOS,
    product: .staticFramework,
    dependencies: [
        .Projects.core
    ]
)
