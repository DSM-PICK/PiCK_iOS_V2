import Foundation
import WatchConnectivity

import WatchAppNetwork

public class Assembler {
    public static let shared = resolve()

    public let watchSessionManager: WatchSessionManager.Type

    init(watchSessionManager: WatchSessionManager.Type) {
        self.watchSessionManager = watchSessionManager
    }

//    func resolve<Service>(_ serviceType: Service.Type) -> Service?
    private static func resolve() -> Assembler {
//        let sessionㅋ
//        let keychain = Keychain.self

        let watchSessionManagerInject = WatchSessionManager.self

        return .init(
            watchSessionManager: watchSessionManagerInject
        )
    }

}
