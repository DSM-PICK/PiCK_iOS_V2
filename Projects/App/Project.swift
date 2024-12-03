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
    .init(
        name: env.targetName,
        platform: env.platform,
        product: .app,
        bundleId: "$(APP_BUNDLE_ID)",
        deploymentTarget: env.deploymentTarget,
        infoPlist: .file(path: "Support/Info.plist"),
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        entitlements: "Support/\(env.appName).entitlements",
        scripts: scripts,
        dependencies: [
            .Projects.flow,
            .SPM.FCM,
            .target(name: "\(env.appName)-Watch")
        ],
        settings: .settings(base: env.baseSetting)
    ),
    .init(
        name: "\(env.targetName)-Watch",
        platform: .watchOS,
        product: .app,
        productName: "\(env.appName)-Watch",
        bundleId: "$(APP_BUNDLE_ID).watchapp",
        infoPlist: .file(path: "WatchApp/Support/Info.plist"),
        sources: ["WatchApp/Sources/**"],
        resources: ["WatchApp/Resources/**"],
        dependencies: [
//            .external(name: "Swinject")
            .WatchModule.watchAppNetwork,
            .WatchModule.watchDesignSystem
        ]
    )
]

let schemes: [Scheme] = [
    .init(
        name: "\(env.targetName)-STAGE",
        shared: true,
        buildAction: .buildAction(targets: ["\(env.targetName)"]),
        runAction: .runAction(configuration: .stage),
        archiveAction: .archiveAction(configuration: .stage),
        profileAction: .profileAction(configuration: .stage),
        analyzeAction: .analyzeAction(configuration: .stage)
    ),
    .init(
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
    packages: [.FCM],
    settings: settings,
    targets: targets,
    schemes: schemes
)
