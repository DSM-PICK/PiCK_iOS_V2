import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "WatchDesignSystem",
    resources: ["Resources/**"],
    destination: .watchOS,
    product: .framework,
    deploymentTarget: .watchOS("9.0"),
    dependencies: [
        .WatchModule.thirdPartyLib
    ]
)
