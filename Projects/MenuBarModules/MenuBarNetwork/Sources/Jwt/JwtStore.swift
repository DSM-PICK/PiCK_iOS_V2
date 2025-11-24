import Foundation
import KeychainSwift

public class JwtStore {
    public static let shared = JwtStore()
    private let keyChain = KeychainImpl()

    public init() {}

    public var accessToken: String? {
        set {
            if let newValue = newValue {
                keyChain.save(type: .accessToken, value: newValue)
            } else {
                keyChain.delete(type: .accessToken)
            }
        }
        get {
            keyChain.load(type: KeychainType.accessToken)
        }
    }

    public var refreshToken: String? {
        set {
            if let newValue = newValue {
                keyChain.save(type: .refreshToken, value: newValue)
            } else {
                keyChain.delete(type: .refreshToken)
            }
        }
        get {
            keyChain.load(type: KeychainType.refreshToken)
        }
    }

    public func toHeader(_ type: KeychainType) -> [String: String] {
        switch type {
        case .accessToken:
            guard let accessToken = self.accessToken, !accessToken.isEmpty else {
                return ["content-type": "application/json"]
            }
            return [
                "content-type": "application/json",
                "Authorization": accessToken
            ]
        case .refreshToken:
            guard let refreshToken = self.refreshToken, !refreshToken.isEmpty else {
                return ["content-type": "application/json"]
            }
            return [
                "content-type": "application/json",
                "X-Refresh-Token": refreshToken
            ]
        case .tokenIsEmpty:
            return ["content-type": "application/json"]
        }
    }

    public func removeToken() {
        keyChain.delete(type: .accessToken)
        keyChain.delete(type: .refreshToken)
    }
}
