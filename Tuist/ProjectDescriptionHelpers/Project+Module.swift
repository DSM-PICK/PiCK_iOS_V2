import Foundation

import ProjectDescription
import DependencyPlugin
import EnvironmentPlugin
import ConfigurationPlugin

let isCI = (ProcessInfo.processInfo.environment["TUIST_CI"] ?? "0") == "1" ? true : false

extension Project {
    public static func makeModule(
        name: String,
        organizationName: String = env.organizationName,
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements? = nil,
        resourceSynthesizers: [ResourceSynthesizer] = .default + [],
        destination: Destinations = env.destination,
        product: Product,
        packages: [Package] = [],
        deploymentTarget: DeploymentTargets = env.deploymentTargets,
        dependencies: [TargetDependency],
        settings: SettingsDictionary = [:],
        configurations: [Configuration] = [],
        additionalPlistRows: [String: ProjectDescription.Plist.Value] = [:]
    ) -> Project {

        let scripts: [TargetScript] = isCI ? [] : [.swiftLint]

        let ldFlagsSettings: SettingsDictionary = product == .framework ?
        ["OTHER_LDFLAGS": .string("$(inherited) -all_load")] :
        ["OTHER_LDFLAGS": .string("$(inherited)")]

        let configurations: [Configuration] = isCI ?
        [
          .debug(name: .stage),
          .release(name: .prod)
        ] :
        [
          .debug(name: .stage, xcconfig: .relativeToXCConfig(type: .stage, name: name)),
          .release(name: .prod, xcconfig: .relativeToXCConfig(type: .prod, name: name))
        ]

        let settings: Settings = .settings(
            base: env.baseSetting
                .merging(.codeSign)
                .merging(settings)
                .merging(ldFlagsSettings),
            configurations: configurations,
            defaultSettings: .recommended
        )

        var allTargets: [Target] = [
            .target(
                name: name,
                destinations: destination,
                product: product,
                bundleId: "\(env.organizationName).\(name)",
                deploymentTargets: deploymentTarget,
                infoPlist: .extendingDefault(with: additionalPlistRows),
                sources: sources,
                resources: resources,
                scripts: scripts,
                dependencies: dependencies
            )
        ]

        let schemes: [Scheme] = [.makeScheme(target: .stage, name: name)]

        return Project(
            name: name,
            organizationName: env.organizationName,
            packages: packages,
            settings: settings,
            targets: allTargets,
            schemes: schemes,
            resourceSynthesizers: resourceSynthesizers
        )
    }
}

extension Scheme {
    static func makeScheme(target: ConfigurationName, name: String) -> Scheme {
        return .scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)"]),
            runAction: .runAction(configuration: target),
            archiveAction: .archiveAction(configuration: target),
            profileAction: .profileAction(configuration: target),
            analyzeAction: .analyzeAction(configuration: target)
        )
    }
    
}
