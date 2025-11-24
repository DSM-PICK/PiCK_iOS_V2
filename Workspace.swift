import ProjectDescription
import EnvironmentPlugin

let workspace = Workspace(
    name: env.appName,
    projects: [
        "Projects/App",
        "Projects/MenuBarModules/MenuBarApp",
        "Projects/MenuBarModules/MenuBarNetwork",
        "Projects/MenuBarModules/MenuBarDesignSystem",
        "Projects/MenuBarModules/MenuBarThirdPartyLib"
    ]
)
