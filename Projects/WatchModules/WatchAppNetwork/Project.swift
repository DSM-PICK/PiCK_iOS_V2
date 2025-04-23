import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "WatchAppNetwork",
    destination: .watchOS,
    product: .staticFramework,
    deploymentTarget: .watchOS("9.0"),
    dependencies: [
        .WatchModule.thirdPartyLib
    ]
)
