import ProjectDescription

public struct ProjectEnvironment {
    public let appName: String
    public let targetName: String
    public let organizationName: String
    public let deploymentTargets: DeploymentTargets
    public let destination: Destinations
    public let watchDestination: Destinations
    public let baseSetting: SettingsDictionary
}

public let env = ProjectEnvironment(
    appName: "PiCK-iOS-V2",
    targetName: "PiCK-iOS-V2",
    organizationName: "com.pick.app",
    deploymentTargets: .iOS("16.0"),
    destination: [.iOS, .macCatalyst],
    watchDestination: .watchOS,
    baseSetting: ["OTHER_LDFLAGS": ["$(inherited) -Objc"]]
)
