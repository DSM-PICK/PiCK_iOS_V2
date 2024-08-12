import Foundation

public struct LoginRequestParams: Encodable {
    public let accountID: String
    public let password: String

    public init(accountID: String, password: String) {
        self.accountID = accountID
        self.password = password
    }
}

