import Foundation

import Core

public struct OutingPassEntity {
    public let userName: String
    public let teacherName: String
    public let time: String?
    public let reason: String?
    public let gcn: String?
    public let type: OutingType.RawValue

    public init(
        userName: String,
        teacherName: String,
        time: String,
        reason: String?,
        gcn: String?,
        type: OutingType.RawValue
    ) {
        self.userName = userName
        self.teacherName = teacherName
        self.time = time
        self.reason = reason
        self.gcn = gcn
        self.type = type
    }
}
