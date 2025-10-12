import Foundation

public struct VerifyEmailCodeRequestParams: Encodable {
    public let mail: String
    public let message: String
    public let title: String

    public init(
        mail: String,
        message: String,
        title: String
    ) {
        self.mail = mail
        self.message = message
        self.title = title
    }

    enum CodingKeys: String, CodingKey {
        case mail
        case message
        case title
    }

}
