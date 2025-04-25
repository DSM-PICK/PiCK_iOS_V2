import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "DesignSystem",
    resources: ["Resources/**"],
    resourceSynthesizers: .default + [
        .custom(
            name: "Lottie",
            parser: .json,
            extensions: ["json"]
        )
    ],
    product: .framework,
    dependencies: [
        .Projects.core
    ]
)
