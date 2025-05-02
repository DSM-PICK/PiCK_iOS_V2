import Foundation

public struct SimpleProfileEntity {
    public let name: String
    public let gcn: String
    public let profile: String?

    public init(
        name: String,
        gcn: String,
        profile: String?
    ) {
        self.name = name
        self.gcn = gcn
        self.profile = profile
    }

}
