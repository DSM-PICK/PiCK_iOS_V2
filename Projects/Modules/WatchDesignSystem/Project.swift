import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "WatchDesignSystem",
    resources: ["Resources/**"],
    platform: .watchOS,
    product: .framework,
    deploymentTarget: .watchOS(targetVersion: "9.0"),
    dependencies: []
)
