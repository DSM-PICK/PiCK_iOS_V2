import Foundation

public enum KeychainType: String {
    case accessToken = "access_token"
    case refreshToken = "refresh_token"
    case tokenIsEmpty

    case id
    case password
}

public protocol Keychain {
    func save(type: KeychainType, value: String)
    func load(type: KeychainType) -> String
    func delete(type: KeychainType)
}
