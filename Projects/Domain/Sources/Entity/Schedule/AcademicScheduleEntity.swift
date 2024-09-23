import Foundation

public struct AcademicScheduleEntityElement {
    public let id: UUID
    public let eventName: String
    public let month: Int
    public let day: Int
    public let dayName: String

    public init(
        id: UUID,
        eventName: String,
        month: Int,
        day: Int,
        dayName: String
    ) {
        self.id = id
        self.eventName = eventName
        self.month = month
        self.day = day
        self.dayName = dayName
    }
}

public typealias AcademicScheduleEntity = [AcademicScheduleEntityElement]
