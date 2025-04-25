import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Presentation",
    resources: ["Resources/**"],
    product: .staticFramework,
    dependencies: [
        .Projects.domain,
        .Module.designSystem
    ]
)
