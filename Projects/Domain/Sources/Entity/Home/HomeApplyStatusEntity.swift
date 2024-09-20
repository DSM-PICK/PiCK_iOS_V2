import Foundation

import Core

public struct HomeApplyStatusEntity {
    public let userID: UUID?
    public let userName: String?
    public let startTime: String?
    public let endTime: String?
    public let classroom: String?
    public let type: OutingType.RawValue?
    
    public init(
        userID: UUID?,
        userName: String?,
        startTime: String?,
        endTime: String?,
        classroom: String?,
        type: OutingType.RawValue?
    ) {
        self.userID = userID
        self.userName = userName
        self.startTime = startTime
        self.endTime = endTime
        self.classroom = classroom
        self.type = type
    }
    
}
