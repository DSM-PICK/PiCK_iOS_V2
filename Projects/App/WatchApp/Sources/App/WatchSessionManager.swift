import Foundation
import WatchConnectivity

import WatchAppNetwork

public final class WatchSessionManager: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = WatchSessionManager()

    private let session = WCSession.default
    private let keychain: Keychain
//    var isReachable: Bool {
//        session.activationState == .activated
//    }

    override init() {
        self.keychain = KeychainImpl()
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }

    func activate() {
        session.activate()
        self.session.activationState == .activated ? print("✅세션 연결 성공") : print("❌세션 연결 실패")
    }

    public func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        print("ㅏㅏㅏㅏㅏㅏ🙃")
        sendMessage(message: [:]) { data in
            guard let accessToken = data["access_token"] as? String else {
                print("🙃 ㅎㅎ")
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
        print("ㅎㅎㅎㅎㅎ🙃")
        guard let accessToken = message["access_token"] as? String else {
            print("accessToken 로드 실패")
            return
        }
        self.keychain.save(type: .accessToken, value: accessToken)

        print("✅accessToken 저장 성공")
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
