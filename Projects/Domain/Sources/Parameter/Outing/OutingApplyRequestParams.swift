import Foundation

import Core

public struct OutingApplyRequestParams: Encodable {
    public let reason: String
    public let startTime: String
    public let endTime: String
    public let applicationType: PickerTimeSelectType.RawValue

    public init(
        reason: String,
        startTime: String,
        endTime: String,
        applicationType: PickerTimeSelectType.RawValue
    ) {
        self.reason = reason
        self.startTime = startTime
        self.endTime = endTime
        self.applicationType = applicationType
    }

}
