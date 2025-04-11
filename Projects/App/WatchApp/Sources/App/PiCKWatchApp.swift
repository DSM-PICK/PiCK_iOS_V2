import SwiftUI
import WatchConnectivity

@main
struct PiCKWatchApp: App {
    init() {
        _ = WatchSessionManager()
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
