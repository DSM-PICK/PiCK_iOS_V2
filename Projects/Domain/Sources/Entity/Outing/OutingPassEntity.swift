import Foundation

import Core

public struct OutingPassEntity {
    public let userName: String
    public let teacherName: String
    public let start: String?
    public let end: String?
    public let reason: String
    public let schoolNum: Int?
    public let grade: Int?
    public let classNum: Int?
    public let num: Int?
    public let type: OutingType.RawValue

    public init(
        userName: String,
        teacherName: String,
        start: String?,
        end: String?,
        reason: String,
        schoolNum: Int?,
        grade: Int?,
        classNum: Int?,
        num: Int?,
        type: OutingType.RawValue
    ) {
        self.userName = userName
        self.teacherName = teacherName
        self.start = start
        self.end = end
        self.reason = reason
        self.schoolNum = schoolNum
        self.grade = grade
        self.classNum = classNum
        self.num = num
        self.type = type
    }
}
