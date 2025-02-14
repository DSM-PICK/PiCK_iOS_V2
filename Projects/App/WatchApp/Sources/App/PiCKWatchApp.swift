import SwiftUI
import WatchKit
import WatchConnectivity

import WatchAppNetwork

@main
struct PiCKWatchApp: App {
    private let watchSessionManager: WatchSessionManager

    init() {
        let session = WCSession.default
        let keychain = KeychainImpl()
        self.watchSessionManager = WatchSessionManager(session: session, keychain: keychain)
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
