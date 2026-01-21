import Foundation

public struct EarlyLeaveApplyRequestParams: Encodable {
    public let reason: String
    public let startTime: String
    public let applicationType: String

    public init(
        reason: String,
        startTime: String,
        applicationType: String
    ) {
        self.reason = reason
        self.startTime = startTime
        self.applicationType = applicationType
    }

    enum CodingKeys: String, CodingKey {
        case reason
        case startTime = "start"
        case applicationType = "application_type"
    }

}
