import Foundation

public struct DetailProfileEntity {
    public let name: String
    public let birthDay: String
    public let grade: Int
    public let classNum: Int
    public let num: Int
    public let accountID: String
    
    public init(
        name: String,
        birthDay: String,
        grade: Int,
        classNum: Int,
        num: Int,
        accountID: String
    ) {
        self.name = name
        self.birthDay = birthDay
        self.grade = grade
        self.classNum = classNum
        self.num = num
        self.accountID = accountID
    }
    
}
