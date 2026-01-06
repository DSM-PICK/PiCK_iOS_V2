import Foundation

public struct SigninRequestParams: Encodable {
    public let accountID: String
    public let password: String
    public let deviceToken: String?
    public let os: String

    public init(
        accountID: String,
        password: String,
        deviceToken: String?,
    ) {
        self.accountID = accountID
        self.password = password
        self.deviceToken = deviceToken
        self.os = "IOS"
    }

    enum CodingKeys: String, CodingKey {
        case accountID = "account_id"
        case password
        case deviceToken = "device_token"
        case os
    }
}
