import Foundation

import Core

public struct OutingPassEntity {
    public let userName: String
    public let teacherName: String
    public let startTime: String
    public let endTime: String
    public let reason: String
    public let schoolNum: Int
    public let type: OutingType.RawValue
    
    public init(
        userName: String,
        teacherName: String,
        startTime: String,
        endTime: String,
        reason: String,
        schoolNum: Int,
        type: OutingType.RawValue
    ) {
        self.userName = userName
        self.teacherName = teacherName
        self.startTime = startTime
        self.endTime = endTime
        self.reason = reason
        self.schoolNum = schoolNum
        self.type = type
    }
}
