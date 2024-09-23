import Foundation

public struct SelfStudyEntityElement {
    public let floor: Int
    public let teacherName: String

    public init(
        floor: Int,
        teacherName: String
    ) {
        self.floor = floor
        self.teacherName = teacherName
    }
}

public typealias SelfStudyEntity = [SelfStudyEntityElement]
