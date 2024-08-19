import Foundation

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
