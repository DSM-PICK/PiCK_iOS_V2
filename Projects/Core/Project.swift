import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Core",
    platform: .iOS,
    product: .staticFramework,
    dependencies: [
        .Module.thirdPartyLib
    ]
)
