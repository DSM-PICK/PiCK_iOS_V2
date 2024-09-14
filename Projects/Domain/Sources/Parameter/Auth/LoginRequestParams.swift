import Foundation

public struct LoginRequestParams: Encodable {
    public let accountID: String
    public let password: String
    public let deviceToken: String?

    public init(
        accountID: String,
        password: String,
        deviceToken: String?
    ) {
        self.accountID = accountID
        self.password = password
        self.deviceToken = deviceToken
    }

}

