import Foundation

public struct DetailNoticeEntity {
    public let title: String
    public let content: String
    public let createAt: String
    public let teacher: String

    public init(
        title: String,
        content: String,
        createAt: String,
        teacher: String
    ) {
        self.title = title
        self.content = content
        self.createAt = createAt
        self.teacher = teacher
    }

}
