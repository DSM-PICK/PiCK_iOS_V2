import ProjectDescription

let config = Config(
    plugins: [
        .local(path: .relativeToManifest("../../Plugins/ConfigurationPlugin")),
        .local(path: .relativeToManifest("../../Plugins/DependencyPlugin")),
        .local(path: .relativeToManifest("../../Plugins/EnvironmentPlugin"))
    ]
)
