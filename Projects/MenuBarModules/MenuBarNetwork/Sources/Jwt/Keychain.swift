import Foundation
import KeychainSwift

public enum KeychainType: String {
    case accessToken = "access_token"
    case refreshToken = "refresh_token"
    case tokenIsEmpty
}

public protocol Keychain {
    func save(type: KeychainType, value: String)
    func load(type: KeychainType) -> String
    func delete(type: KeychainType)
}

public struct KeychainImpl: Keychain {
    private let keychain = KeychainSwift()

    public init() {}

    public func save(type: KeychainType, value: String) {
        keychain.set(value, forKey: type.rawValue)
    }

    public func load(type: KeychainType) -> String {
        return keychain.get(type.rawValue) ?? "Failed To Load Keychain Value"
    }

    public func delete(type: KeychainType) {
        keychain.delete(type.rawValue)
    }
}
