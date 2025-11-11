import Foundation

public struct PasswordChangeRequestParams: Encodable {
    public let password: String
    public let accountId: String
    public let code: String

    public init(
        password: String,
        accountId: String,
        code: String
    ) {
        self.password = password
        self.accountId = accountId
        self.code = code
    }

    enum CodingKeys: String, CodingKey {
        case password
        case accountId = "account_id"
        case code
    }
}
