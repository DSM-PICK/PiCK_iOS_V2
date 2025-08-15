import Foundation

public struct MailCodeCheckRequestParams: Encodable {
    public let mail: String
    public let code: String

    public init(
        mail: String,
        code: String
    ) {
        self.mail = mail
        self.code = code
    }

    enum CodingKeys: String, CodingKey {
        case mail
        case code
    }

}
