import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "WatchAppNetwork",
    platform: .watchOS,
    product: .staticFramework,
    deploymentTarget: .watchOS(targetVersion: "9.0"),
    dependencies: [
        .WatchModule.thirdPartyLib
    ]
)
