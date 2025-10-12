import Foundation

public struct MailCodeCheckRequestParams: Encodable {
    public let email: String
    public let code: String

    public init(
        email: String,
        code: String
    ) {
        self.email = email
        self.code = code
    }

    enum CodingKeys: String, CodingKey {
        case email
        case code
    }

}
