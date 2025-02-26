import Foundation
import WatchConnectivity

import WatchAppNetwork

public class WatchSessionManager: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = WatchSessionManager()

    private let session: WCSession
    private let keychain: Keychain
    var isReachable: Bool {
        session.isReachable
    }

    override private init() {
        self.session = .default
        self.keychain = KeychainImpl()
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }

    func activate() {
        session.activate()
    }

    public func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        sendMessage(message: [:]) { data in
            guard let accessToken = data["access_token"] as? String else {
                return
            }
            self.keychain.save(type: .accessToken, value: accessToken)
        } error: { error in
            print("\(error.localizedDescription)")
        }
    }

    public func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any],
        replyHandler: @escaping ([String: Any]) -> Void
    ) {
        guard let accessToken = message["access_token"] as? String else {
            print("accessToken 로드 실패")
            return
        }
        self.keychain.save(type: .accessToken, value: accessToken)
    }

}

extension WatchSessionManager {
    func sendMessage(
        message: [String: Any],
        reply: @escaping ([String: Any]) -> Void,
        error: ((Error) -> Void)? = nil
    ) {
        guard session.activationState == .activated else {
            return
        }
        session.sendMessage(message, replyHandler: reply, errorHandler: error)
    }

}
