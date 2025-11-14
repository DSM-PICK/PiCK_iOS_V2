import Foundation

public struct SignupRequestParams: Encodable {
    public let accountID: String
    public let password: String
    public let name: String
    public let grade: Int
    public let classNum: Int
    public let num: Int
    public let code: String
    public let deviceToken: String?

    public init(
        accountID: String,
        password: String,
        name: String,
        grade: Int,
        classNum: Int,
        num: Int,
        code: String,
        deviceToken: String?

    ) {
        self.accountID = accountID
        self.password = password
        self.name = name
        self.grade = grade
        self.classNum = classNum
        self.num = num
        self.code = code
        self.deviceToken = deviceToken
    }

    enum CodingKeys: String, CodingKey {
        case accountID = "account_id"
        case password
        case name
        case grade
        case classNum = "class_num"
        case num
        case code
        case deviceToken = "device_token"
    }

}
