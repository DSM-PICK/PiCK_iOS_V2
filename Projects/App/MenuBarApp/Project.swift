import Foundation
import ProjectDescription
import ProjectDescriptionHelpers
import EnvironmentPlugin
import DependencyPlugin
import ConfigurationPlugin

let configurations: [Configuration] = [
    .debug(name: .stage, xcconfig: .relativeToXCConfig(type: .stage, name: "MenuBarApp")),
    .release(name: .prod, xcconfig: .relativeToXCConfig(type: .prod, name: "MenuBarApp"))
]

let settings: Settings = .settings(
    base: env.baseSetting,
    configurations: configurations,
    defaultSettings: .recommended
)

let targets: [Target] = [
    .target(
        name: "MenuBarApp",
        destinations: .macOS,
        product: .app,
        bundleId: "com.pick.MenuBarApp2",
        deploymentTargets: .macOS("13.0"),
        infoPlist: .file(path: "Support/Info.plist"),
        sources: ["Sources/**"],
        resources: nil,
        entitlements: "Support/MenuBarApp.entitlements",
        dependencies: [
            .MenuBarModule.menuBarDesignSystem,
            .MenuBarModule.menuBarNetwork,
            .MenuBarModule.menuBarThirdPartyLib
        ],
        settings: .settings(base: env.baseSetting)
    )
]

let schemes: [Scheme] = [
    .scheme(
        name: "MenuBarApp-STAGE",
        shared: true,
        buildAction: .buildAction(targets: ["MenuBarApp"]),
        runAction: .runAction(configuration: .stage),
        archiveAction: .archiveAction(configuration: .stage),
        profileAction: .profileAction(configuration: .stage),
        analyzeAction: .analyzeAction(configuration: .stage)
    ),
    .scheme(
        name: "MenuBarApp-PROD",
        shared: true,
        buildAction: .buildAction(targets: ["MenuBarApp"]),
        runAction: .runAction(configuration: .prod),
        archiveAction: .archiveAction(configuration: .prod),
        profileAction: .profileAction(configuration: .prod),
        analyzeAction: .analyzeAction(configuration: .prod)
    )
]

let project = Project(
    name: "MenuBarApp",
    organizationName: env.organizationName,
    settings: settings,
    targets: targets,
    schemes: schemes
)
