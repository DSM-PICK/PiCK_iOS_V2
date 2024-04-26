import ProjectDescription

public extension ConfigurationName {
    static var stage: ConfigurationName { configuration(ProjectDeployTarget.stage.rawValue) }
    static var prod: ConfigurationName { configuration(ProjectDeployTarget.prod.rawValue) }
}

public extension Array where Element == Configuration {
    static let `default`: [Configuration] = [
        .debug(name: .stage, xcconfig: .shared),
        .release(name: .prod, xcconfig: .shared),
    ]
}
