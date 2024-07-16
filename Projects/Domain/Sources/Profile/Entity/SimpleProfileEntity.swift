import Foundation

public struct SimpleProfileEntity {
    public let name: String
    public let grade: Int
    public let classNum: Int
    public let num: Int
    
    public init(
        name: String,
        grade: Int,
        classNum: Int,
        num: Int
    ) {
        self.name = name
        self.grade = grade
        self.classNum = classNum
        self.num = num
    }
    
}
