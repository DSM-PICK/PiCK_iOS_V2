import Foundation
import WatchConnectivity

import Core

protocol WatchDataSource {
    func sendToken()
}

class WatchDataSourceImpl: NSObject, WatchDataSource, WCSessionDelegate {
    private var keychain: Keychain
    private var session = WCSession.default

//    override init() {
//        self.session = .default
//        if WCSession.isSupported() {
//            session.delegate = self
//            session.activate()
//            print("init👍")
//        }
//    }
    init(keychain: Keychain) {
        self.keychain = keychain
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
            print("active👍")
        }
    }

    func sendToken() {
        if session.isReachable {
            // this is a meaningless message, but it's enough for our purposes
            let message: [String: Any] = [
                "access_token": keychain.load(type: .accessToken)
            ]
            session.sendMessage(message, replyHandler: nil)
        }
        print("👍 sendToken 실행")
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
        let message: [String: Any] = [
            "access_token": keychain.load(type: .accessToken)
        ]

        sendMessage(message: message) { _ in } error: { error in
            print("WCSession 메시지 전송 실패: \(error.localizedDescription)")
        }
        print("✉️Message: \(message)")

//                let message: [String: Any] = [
//                    "access_token": keychain.load(type: .accessToken)
//                ]
//                sendMessage(message: message) { _ in } error: { error in
//                    print(error.localizedDescription)
//                }
    }

    public func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any],
        replyHandler: @escaping ([String: Any]) -> Void
    ) {
        let message: [String: Any] = [
            "access_token": keychain.load(type: .accessToken)
        ]
        replyHandler(message)
        print("didReceive👍")
        
    }

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
