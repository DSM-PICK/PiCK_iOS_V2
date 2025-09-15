import Foundation
import WatchConnectivity

import Core

protocol WatchDataSource {
    func activate()
}

class WatchDataSourceImpl: NSObject, WatchDataSource, WCSessionDelegate {
    private var keychain = KeychainImpl()
    private var session: WCSession!

    override init() {
        super.init()
        self.session = .default
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }

    func activate() {
        session.activate()
    }

    public func sessionDidBecomeInactive(_ session: WCSession) { }
    public func sessionDidDeactivate(_ session: WCSession) { }

    public func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        guard activationState == .activated else {
            print("WCSession 활성화 실패")
            return
        }

        let message: [String: Any] = [
            "access_token": keychain.load(type: .accessToken)
        ]

        session.sendMessage(message) { _ in } errorHandler: { error in
            print("WCSession 메시지 전송 실패: \(error.localizedDescription)")
        }

    }

    public func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any],
        replyHandler: @escaping ([String: Any]) -> Void
    ) {
        let response: [String: Any] = ["access_token": keychain.load(type: .accessToken)]
        replyHandler(response)
    }
}
