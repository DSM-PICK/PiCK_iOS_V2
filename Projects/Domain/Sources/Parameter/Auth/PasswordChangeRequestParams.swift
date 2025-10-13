import Foundation

public struct PasswordChangeRequestParams: Encodable {
    public let password: String
    public let acountId: String
    public let code: String

    public init(
        password: String,
        acountId: String,
        code: String
    ) {
        self.password = password
        self.acountId = acountId
        self.code = code
    }
}
