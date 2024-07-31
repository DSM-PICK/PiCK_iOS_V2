import Foundation

import Core

public class TokenStorage {
    public static let shared = TokenStorage()
    private let keyChain = KeychainImpl()

    public var accessToken: String? {
        set {
            keyChain.save(type: .accessToken, value: KeychainType.accessToken.rawValue)
        }
        get {
            keyChain.load(type: KeychainType.accessToken)
        }
    }

    public var refreshToken: String? {
        set {
            keyChain.save(type: .refreshToken, value: KeychainType.refreshToken.rawValue)
        }
        get {
            keyChain.load(type: KeychainType.refreshToken)
        }
    }

    public func toHeader(_ tokenType: KeychainType) -> [String: String] {
        guard let accessToken = self.accessToken,
              let refreshToken = self.refreshToken
        else {
            return ["content-type": "application/json"]
        }

        switch tokenType {
        case .accessToken:
            return [
                "content-type": "application/json",
                "Authorization": accessToken
            ]
        case .refreshToken:
            return [
                "content-type": "application/json",
                "X-Refresh-Token": refreshToken
            ]
        case .tokenIsEmpty:
            return ["content-type": "application/json"]
        }
    }

    public func removeToken() {
        self.accessToken = nil
        self.refreshToken = nil
    }
}
