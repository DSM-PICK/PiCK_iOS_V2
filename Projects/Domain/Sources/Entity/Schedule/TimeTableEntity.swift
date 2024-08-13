import Foundation

import Core

public struct TimeTableEntity {
    public let date: String
    public let timetables: [TimeTableEntityElement]

    public init(
        date: String,
        timetables: [TimeTableEntityElement]
    ) {
        self.date = date
        self.timetables = timetables
    }

}

public struct TimeTableEntityElement {
    public let id: UUID
    public let period: Int
    public let subjectName: String
    public let subjectImage: String

    public init(
        id: UUID,
        period: Int,
        subjectName: String,
        subjectImage: String
    ) {
        self.id = id
        self.period = period
        self.subjectName = subjectName
        self.subjectImage = subjectImage
    }

}

public typealias WeekTimeTableEntity = [TimeTableEntity]
