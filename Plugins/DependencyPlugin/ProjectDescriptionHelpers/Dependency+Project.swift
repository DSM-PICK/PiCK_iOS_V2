import ProjectDescription

public extension TargetDependency {
    struct Projects {}
    struct Module {}
}

public extension TargetDependency.Projects {
    static let core = project(name: "Core")
    static let data = project(name: "Data")
    static let domain = project(name: "Domain")
    static let flow = project(name: "Flow")
    static let presentation = project(name: "Presentation")
    
    static func project(name: String) -> TargetDependency {
        return .project(
            target: name,
            path: .relativeToRoot("Projects/\(name)")
        )
    }
}

public extension TargetDependency.Module {
    static let appNetwork = module(name: "AppNetwork")
    static let designSystem = module(name: "DesignSystem")
    static let thirdPartyLib = module(name: "ThirdPartyLib")
    static let watchAppNetwork = module(name: "WatchAppNetwork")
    static let watchDesignSystem = module(name: "WatchDesignSystem")

    static func module(name: String) -> TargetDependency {
        return .project(
            target: name,
            path: .relativeToRoot("Projects/Modules/\(name)")
        )
    }
}
