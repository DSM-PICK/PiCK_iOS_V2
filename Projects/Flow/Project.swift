import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Flow",
    platform: .iOS,
    product: .staticFramework,
    dependencies: [
        .Projects.presentation,
        .Projects.data,
        .SPM.FCM
    ]
)
