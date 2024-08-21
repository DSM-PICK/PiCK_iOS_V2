import Foundation

public struct BugRequestParams: Encodable {
    public let title: String
    public let model: String = "IOS"
    public let content: String
    public let fileName: [String]

    public init(
        title: String,
        content: String,
        fileName: [String]
    ) {
        self.title = title
        self.content = content
        self.fileName = fileName
    }

}
