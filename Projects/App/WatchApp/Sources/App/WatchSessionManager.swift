import Foundation
import WatchConnectivity

import WatchAppNetwork

public class WatchSessionManager: NSObject, WCSessionDelegate, ObservableObject {
    private let session: WCSession
    private let keychain: Keychain

    init(session: WCSession, keychain: Keychain) {
        self.session = session
        self.keychain = keychain
        super.init()
        session.delegate = self
        session.activate()
    }

    public func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: (any Error)?
    ) {
        print("Watch WCSession 활성화: \(activationState)\n")
        session.sendMessage([:]) { [weak self] reply in
            guard let self,
                  let aceessToken = reply["access_token"] as? String
            else {
                return
            }
            self.keychain.save(type: .accessToken, value: aceessToken)
        }
    }
    public func session(
        _ session: WCSession,
        didReceiveMessage message: [String : Any],
        replyHandler: @escaping ([String : Any]) -> Void
    ) {
        guard let accessToken = message["access_token"] as? String
        else {
            return
        }
        self.keychain.save(type: .accessToken, value: accessToken)
    }
}
