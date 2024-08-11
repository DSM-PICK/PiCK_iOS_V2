import Foundation

public struct SimpleProfileEntity {
    public let name: String
    public let grade: Int
    public let classNum: Int
    public let num: Int
    public let profile: String?

    public init(
        name: String,
        grade: Int,
        classNum: Int,
        num: Int,
        profile: String?
    ) {
        self.name = name
        self.grade = grade
        self.classNum = classNum
        self.num = num
        self.profile = profile
    }

}
