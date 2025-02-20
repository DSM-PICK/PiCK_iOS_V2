import SwiftUI
import WatchConnectivity

@main
struct PiCKWatchApp: App {

    init() {
        WatchSessionManager.shared.activate()
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
