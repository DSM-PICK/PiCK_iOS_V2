import Foundation

public struct OutingApplyRequestParams: Encodable {
    public let reason: String
    public let startTime: String
    public let endTime: String

    public init(
        reason: String,
        startTime: String,
        endTime: String
    ) {
        self.reason = reason
        self.startTime = startTime
        self.endTime = endTime
    }

}

public struct EarlyLeaveApplyRequestParams: Encodable {
    public let reason: String
    public let startTime: String

    public init(
        reason: String,
        startTime: String
    ) {
        self.reason = reason
        self.startTime = startTime
    }

}
