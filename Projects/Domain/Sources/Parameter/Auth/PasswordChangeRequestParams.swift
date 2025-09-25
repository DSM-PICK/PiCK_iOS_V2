import Foundation

public struct PasswordChangeRequestParams: Encodable {
    public let password: String
    public let code: String

    public init(
        password: String,
        code: String
    ) {
        self.password = password
        self.code = code
    }
}
