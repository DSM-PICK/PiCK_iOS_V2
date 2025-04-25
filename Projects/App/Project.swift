import Foundation
import ProjectDescription
import ProjectDescriptionHelpers
import EnvironmentPlugin
import DependencyPlugin
import ConfigurationPlugin

let isCI: Bool = (ProcessInfo.processInfo.environment["TUIST_CI"] ?? "0") == "1"

let configurations: [Configuration] = [
    .debug(name: .stage, xcconfig: .relativeToXCConfig(type: .stage, name: env.targetName)),
    .release(name: .prod, xcconfig: .relativeToXCConfig(type: .prod, name: env.targetName))
]

let settings: Settings = .settings(
    base: env.baseSetting,
    configurations: configurations,
    defaultSettings: .recommended
)

let scripts: [TargetScript] = isCI ? [.googleInfoPlistScripts] : [.swiftLint, .googleInfoPlistScripts]

let targets: [Target] = [
    .target(
        name: env.targetName,
        destinations: env.destination,
        product: .app,
        bundleId: "$(APP_BUNDLE_ID)",
        deploymentTargets: env.deploymentTargets,
        infoPlist: .file(path: "Support/Info.plist"),
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        entitlements: "Support/\(env.appName).entitlements",
        scripts: scripts,
        dependencies: [
            .Projects.flow,
            .target(name: "\(env.appName)-Watch")
        ],
        settings: .settings(base: env.baseSetting)
    ),
    .target(
        name: "\(env.targetName)-Watch",
        destinations: env.watchDestination,
        product: .app,
        productName: "\(env.appName)-Watch",
        bundleId: "$(WATCH_APP_BUNDLE_ID)",
        infoPlist: .file(path: "WatchApp/Support/Info.plist"),
        sources: ["WatchApp/Sources/**"],
        resources: ["WatchApp/Resources/**"],
        dependencies: [
            .WatchModule.watchAppNetwork,
            .WatchModule.watchDesignSystem
        ]
    )
]

let schemes: [Scheme] = [
    .scheme(
        name: "\(env.targetName)-STAGE",
        shared: true,
        buildAction: .buildAction(targets: ["\(env.targetName)"]),
        runAction: .runAction(configuration: .stage),
        archiveAction: .archiveAction(configuration: .stage),
        profileAction: .profileAction(configuration: .stage),
        analyzeAction: .analyzeAction(configuration: .stage)
    ),
    .scheme(
        name: "\(env.targetName)-PROD",
        shared: true,
        buildAction: .buildAction(targets: ["\(env.targetName)"]),
        runAction: .runAction(configuration: .prod),
        archiveAction: .archiveAction(configuration: .prod),
        profileAction: .profileAction(configuration: .prod),
        analyzeAction: .analyzeAction(configuration: .prod)
    )
]

let project = Project(
    name: env.targetName,
    organizationName: env.organizationName,
    packages: [.Firebase],
    settings: settings,
    targets: targets,
    schemes: schemes
)
